//
//  Methods.swift
//  DefenceBank
//
//  Created by Cooper on 16/1/2023.
//

import Foundation
import KeychainAccess

let KEYCHAIN_SERVICE = "com.cooperbeltrami.DefenceBank"

let BASE_URL = "https://digital.defencebank.com.au"
let URL_AUTH = "\(BASE_URL)/api/ajaxlogin/login"
let URL_ACCOUNTS = "\(BASE_URL)/platform.axd?u=account%2FGetAccountsBasicData"
let URL_TRANSACTIONS = "\(BASE_URL)/platform.axd?u=transaction%2FGetTransactionHistoryEnhanced"
let URL_UNCOLLECTED = "\(BASE_URL)/platform.axd?u=account%2FGetUncollectedFunds"

var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

func saveCredentials(credentials: Credentials) {
    let keychain = Keychain(service: KEYCHAIN_SERVICE)
    
    keychain["member_number"] = credentials.MemberNumber
    keychain["password"] = credentials.Password
    keychain["cookie"] = credentials.Cookie
}

func getCredentials() -> Credentials {
    let keychain = Keychain(service: KEYCHAIN_SERVICE)
    let credentials = Credentials(
        Cookie: keychain["cookie"] ?? "",
        MemberNumber: keychain["member_number"] ?? "",
        Password: keychain["password"] ?? ""
    )
    
    return credentials
}

func makeRequest(urlString: String, httpMethod: String, body: [String: AnyHashable]? = nil, headers: [String: String]? = nil) async throws -> (Data, URLResponse) {
    guard let url = URL(string: urlString) else {
        throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = httpMethod
    request.httpShouldHandleCookies = true
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Add custom headers
    headers?.forEach { key, value in
        request.setValue(value, forHTTPHeaderField: key)
    }
    
    // Add body if available
    if let body = body {
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    }
    
    let (data, response) = try await URLSession.shared.data(for: request)
    return (data, response)
}

func decodeResponse<T: Decodable>(data: Data, type: T.Type) async -> T? {
    do {
        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
        return decodedResponse
    } catch {
        print("Decoding error: \(error.localizedDescription)")
        return nil
    }
}

func fetchCookies(from response: URLResponse) -> [String: String] {
    var cookies = [String: String]()
    
    guard let httpResponse = response as? HTTPURLResponse else {
        return cookies
    }
    
    // Extract the cookie information from the response headers
    let fields = httpResponse.allHeaderFields as? [String: String] ?? [:]
    guard let url = response.url else { return cookies }
    
    // Get cookies from the response header fields
    let cookiesData = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
    
    for cookie in cookiesData {
        cookies[cookie.name] = cookie.value
    }
    
    return cookies
}

func refreshCookie() async {
    let credentials = getCredentials()
    
    let body: [String: AnyHashable] = [
        "MemberNumber": credentials.MemberNumber,
        "Password": credentials.Password
    ]
    
    do {
        // Fetch both the raw data and the response
        let (_, response) = try await makeRequest(urlString: URL_AUTH, httpMethod: "POST", body: body)
        
        // Extract cookies from the response headers
        let cookies = fetchCookies(from: response)
        
        // Return the "DigitalBanking" cookie, if available
        let authCookie = cookies["DigitalBanking"] ?? ""
        
        let credentials = Credentials(
            Cookie: authCookie,
            MemberNumber: credentials.MemberNumber,
            Password: credentials.Password
        )
        
        saveCredentials(credentials: credentials)
    } catch {
        print("Error refreshing cookie: \(error)")
    }
}

func fetchData<T: Decodable>(urlString: String, body: [String: AnyHashable]? = nil) async -> T? {
    let credentials = getCredentials()
    
    let headers: [String: String] = [
        "Cookie": "DigitalBanking=\(credentials.Cookie)"
    ]
    
    do {
        
        // Fetch both the data and the response (URLResponse) from the request
        let (data, response) = try await makeRequest(urlString: urlString, httpMethod: "POST", body: body, headers: headers)
        
        if let httprequest = response as? HTTPURLResponse {
            
            // If status code is 400, the cookie has expired and must be refreshed
            if httprequest.statusCode == 400 {
                await refreshCookie()
            } else {
                
                // Decode the response data into the specified type
                if let decodedData: T = await decodeResponse(data: data, type: T.self) {
                    return decodedData
                }
            }
        }
    } catch {
        print("Error fetching data: \(error.localizedDescription)")
    }
    
    return nil
}

func getCookie(member_number: String, password: String) async -> String {
    guard let url = URL(string: URL_AUTH) else {
        return ""
    }
    
    var cookies = [String: String]()
    
    // Request payload
    let body: [String: AnyHashable] = [
        "MemberNumber": member_number,
        "Password": password
    ]
    
    // Create URL request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    // Create URLSession with async/await support
    let session = URLSession.shared
    
    do {
        // Perform the request asynchronously and await its response
        let (_, response) = try await session.data(for: request)
        
        // Gather URL response data from request
        guard
            let url = response.url,
            let httpResponse = response as? HTTPURLResponse,
            let fields = httpResponse.allHeaderFields as? [String: String]
        else {
            return ""
        }
        
        // Get cookies from the response headers
        let cookiesData = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        
        // Add cookies to the dictionary
        for cookie in cookiesData {
            cookies[cookie.name] = cookie.value
        }
        
    } catch {
        // Handle error if the request fails
        print("Error during network request: \(error)")
        return ""
    }
    
    // Return the value of the "DigitalBanking" cookie, or an empty string if not found
    return cookies["DigitalBanking"] ?? ""
}

func getAccounts() async -> [Account] {
    let body: [String: AnyHashable] = [
        "ForceFetchData": true
    ]
    
    if let accounts: [Account] = await fetchData(urlString: URL_ACCOUNTS, body: body) {
        return accounts
    }
    
    return []
}


func getTransactions(account_number: String) async -> [Transaction] {
    let body: [String: AnyHashable] = [
        "AccountNumber": account_number
    ]
    
    if let transactions: TransactionResponse = await fetchData(urlString: URL_TRANSACTIONS, body: body) {
        return transactions.TransactionDetails ?? []
    }
    
    return []
}

func getUncollected(account_number: String) async -> [Uncollected] {
    let body: [String: AnyHashable] = [
        "AccountNumber": account_number,
        "IncludeVisaRefundType": true
    ]
    
    if let uncollected: UncollectedResponse = await fetchData(urlString: URL_UNCOLLECTED, body: body) {
        return uncollected.UncollectedFunds ?? []
    }
    
    return []
}

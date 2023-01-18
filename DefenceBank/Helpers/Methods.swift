//
//  Helpers.swift
//  DefenceBank
//
//  Created by Cooper on 16/1/2023.
//

import Foundation
import KeychainAccess

let KEYCHAIN_SERVICE = "com.cooperbeltrami.DefenceBank"

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

func getCookie(member_number:String, password:String) -> String {
    guard let url = URL(string: "https://digital.defencebank.com.au/api/ajaxlogin/login") else {
        return ""
    }
    
    var cookies = [String:String]()
    let sem = DispatchSemaphore.init(value: 0)
    
    // Request payload
    let body: [String: AnyHashable] = [
        "MemberNumber": member_number,
        "Password": password
    ]
    
    // Create url request
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    // Create url session
    let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // Make request and get data
    let task = session.dataTask(with: request) { data, response, error in
        defer { sem.signal() }
        
        // Gather url response data from request
        guard
            let url = response?.url,
            let httpResponse = response as? HTTPURLResponse,
            let fields = httpResponse.allHeaderFields as? [String: String]
        else { return }

        // Get cookies from request
        let cookiesData = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        
        // Add cookies to dictionary
        for cookie in cookiesData {
            cookies[cookie.name] = cookie.value
        }
    }
    
    task.resume()
    
    // This line will wait until semaphore has been signaled
    // which will be once the data task is completed
    sem.wait()
    
    return cookies["DigitalBanking"] ?? ""
}

func getTransactions(account_number: String) -> [Transaction] {
    var temp_transactions = _getTranasactions(account_number: account_number)
    
    if temp_transactions == [] {
        temp_transactions = _getTranasactions(account_number: account_number)
    }
    
    return temp_transactions
}

func _getTranasactions(account_number: String) -> [Transaction] {
    print("GET TRANSACTIONS")
    
    guard let url = URL(string: "https://digital.defencebank.com.au/platform.axd?u=transaction%2FGetTransactionHistoryEnhanced") else {
        return []
    }
    
    var transactions: [Transaction] = []
    
    let credentials = getCredentials()
    let sem = DispatchSemaphore.init(value: 0)
    
    print("COOKIE: \(credentials.Cookie)")
    print("ACCOUNT NUMBER: \(account_number)")
    
    // Request payload
    let body: [String: AnyHashable] = [
        "AccountNumber": account_number
    ]
    
    // Create url request
    var request = URLRequest(url: url)
    
    request.httpMethod = "POST"
    request.httpShouldHandleCookies = true
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("DigitalBanking=\(credentials.Cookie)", forHTTPHeaderField: "Cookie")
    request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    
    // Make request and get accounts
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        defer { sem.signal() }
        
        guard let data = data, error == nil else {
            return
        }
        
        do {
            let response = try JSONDecoder().decode(TransactionResponse.self, from: data)
            
            transactions = response.TransactionDetails ?? []
        } catch {
            print("ERROR: \(error.localizedDescription)")
            
            // Most likely the data model is different, this means the
            // data is probably the error rather than accounts.
            print("INVALID COOKIE")

            // Let's try getting a new token and trying to gather
            // accounts again.
            let credentials = getCredentials()

            // Request a new cookie
            let cookie = getCookie(
                member_number: credentials.MemberNumber,
                password: credentials.Password
            )

            print("REFRESHED COOKIE: \(cookie)")

            // Save the cookie
            let updatedCredentials = Credentials(
                Cookie: cookie,
                MemberNumber: credentials.MemberNumber,
                Password: credentials.Password
            )

            saveCredentials(credentials: updatedCredentials)
        }
    }
    
    task.resume()
    sem.wait()
    
    return transactions
}

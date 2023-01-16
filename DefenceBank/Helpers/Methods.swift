//
//  Helpers.swift
//  DefenceBank
//
//  Created by Cooper on 16/1/2023.
//

import Foundation
import KeychainAccess

let KEYCHAIN_SERVICE = "com.cooperbeltrami.DefenceBank"

func saveCredentials(member_number:String, password:String, cookie:String) {
    let keychain = Keychain(service: KEYCHAIN_SERVICE)
    
    keychain["member_number"] = member_number
    keychain["password"] = password
    keychain["cookie"] = cookie
}

func getCredentials() -> Dictionary<String, String> {
    let keychain = Keychain(service: KEYCHAIN_SERVICE)
    var credentials = Dictionary<String, String>()
    
    credentials["member_number"] = keychain["member_number"]
    credentials["password"] = keychain["password"]
    credentials["cookie"] = keychain["cookie"]
    
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

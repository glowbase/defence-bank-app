//
//  AccountListModel.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import Foundation

final class AppDataModel: ObservableObject {
    @Published var accounts: [Account] = []
    
    init() {
        var temp_accounts = getAccounts()
        
        // Tring to get accounts the first time might fail if
        // the cookie is invalid. The getAccounts() function
        // has the logic to generate a new token and save it
        // but will not reinvoke itself so we are doing it here
        if temp_accounts == [] {
            temp_accounts = getAccounts()
        }
        
        self.accounts = temp_accounts
    }
    
    func getAccounts() -> [Account] {
        guard let url = URL(string: "https://digital.defencebank.com.au/platform.axd?u=account%2FGetAccountsBasicData") else {
            return []
        }
        
        var accounts: [Account] = []
        
        let credentials = getCredentials()
        let cookie = credentials["cookie"] ?? ""
        
        let sem = DispatchSemaphore.init(value: 0)
        
        // Request payload
        let body: [String: AnyHashable] = [
            "ForceFetchData": true
        ]
        
        // Create url request
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpShouldHandleCookies = true
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("DigitalBanking=\(cookie)", forHTTPHeaderField: "Cookie")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        // Make request and get accounts
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            defer { sem.signal() }
            
            guard let data = data, error == nil else {
                return
            }
            
            do {
                accounts = try JSONDecoder().decode([Account].self, from: data)
            } catch {
                // Most likely the data model is different, this means the
                // data is probably the error rather than accounts.
                print("ACCOUNTS FETCH FAILED, TRYING AGAIN")
                
                // Let's try getting a new token and trying to gather
                // accounts again.
                let credentials = getCredentials()
                
                let member_number = credentials["member_number"] ?? ""
                let password = credentials["password"] ?? ""
                
                // Request a new cookie
                let cookie = getCookie(
                    member_number: member_number,
                    password: password
                )
                
                // Save the cookie
                saveCredentials(
                    member_number: member_number,
                    password: password,
                    cookie: cookie
                )
            }
        }
        
        task.resume()
        sem.wait()
        
        return accounts
    }

}

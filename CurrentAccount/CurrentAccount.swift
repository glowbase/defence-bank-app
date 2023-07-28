//
//  CurrentAccount.swift
//  CurrentAccount
//
//  Created by Cooper on 17/1/2023.
//

import WidgetKit
import SwiftUI
import KeychainAccess

let KEYCHAIN_SERVICE = "com.cooperbeltrami.DefenceBank"

let previewAccountData = Account(
    AccountNumber: "20392984",
    Description: "Everyday",
    CurrentBalance: 103.9,
    AvailableBalance: 294.9,
    ClassDescription: "Everyday Access"
)

struct Credentials {
    let Cookie: String
    let MemberNumber: String
    let Password: String
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

func getAccounts() -> [Account] {
    print("GET ACCOUNTS")

    guard let url = URL(string: "https://digital.defencebank.com.au/platform.axd?u=account%2FGetAccountsBasicData") else {
        return []
    }

    var accounts: [Account] = []

    let credentials = getCredentials()
    let sem = DispatchSemaphore.init(value: 0)

    print("COOKIE: \(credentials.Cookie)")

    // Request payload
    let body: [String: AnyHashable] = [
        "ForceFetchData": true
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
            accounts = try JSONDecoder().decode([Account].self, from: data)
        } catch {
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

    return accounts
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> AccountEntry {
        return AccountEntry(date: Date(), account: previewAccountData)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (AccountEntry) -> ()) {
        let entry = AccountEntry(date: Date(), account: previewAccountData)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let futureDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!

        let account = getAccounts()[0]
        
        let entry = AccountEntry(date: currentDate, account: account)
        let timeline = Timeline(entries: [entry], policy: .after(futureDate))
        
        completion(timeline)
    }
}

struct AccountEntry: TimelineEntry {
    let date: Date
    let account: Account
}

struct Account: Decodable {
    let AccountNumber: String
    let Description: String
    let CurrentBalance: Double
    let AvailableBalance: Double
    let ClassDescription: String
}

extension View {
    func widgetBackground(backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

extension View {
    func widgetView() -> some View {
        return RoundedRectangle(cornerRadius: 0, style: .continuous)
            .fill(
                LinearGradient(
                    gradient: .init(colors: [.pink, Color("AccentColor")]),
                    startPoint: .top, endPoint: .bottom
            ))
    }
}

struct CurrentAccountEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack() {
            RoundedRectangle(cornerRadius: 0, style: .continuous)
                .fill(
                    LinearGradient(
                        gradient: .init(colors: [.pink, Color("AccentColor")]),
                        startPoint: .top, endPoint: .bottom
                ))
            HStack() {
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.account.Description)
                        .bold()
                        .font(.subheadline)
                    
                    Text(entry.account.AvailableBalance, format: .currency(code: "AUD"))
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scaledToFit()
                        .minimumScaleFactor(0.5)
                        .font(.title)
                    
                    Spacer()
                    
                    Text("Last updated at")
                        .font(.footnote)
                    
                    Text(entry.date, style: .time)
                        .font(.footnote)
                    
                    Spacer()
                    
                    Image(systemName: "creditcard.fill")
                        .padding(.bottom, 4)
                }
                .padding(.all, 16)
                .foregroundColor(.white)
                
                Spacer()
            }
        }
        .widgetBackground(backgroundView: widgetView())
    }
}

struct CurrentAccount: Widget {
    let kind: String = "CurrentAccount"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CurrentAccountEntryView(entry: entry)
        }
        .configurationDisplayName("Defence Bank")
        .description("View your account balance.")
        .contentMarginsDisabled()
    }
}

struct CurrentAccount_Previews: PreviewProvider {
    static var previews: some View {
        CurrentAccountEntryView(entry: AccountEntry(date: Date(), account: previewAccountData))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

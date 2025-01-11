//
//  AccountsView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct AccountsView: View {
    @State private var accounts: [Account] = []
    @State private var groupedAccounts: [(classDescription: String, accounts: [Account])] = []
    @State private var isLoading: Bool = true
    @State private var query: String = ""
    @State private var netPosition: Double = 0

    var body: some View {
        List {
            if isLoading || accounts.isEmpty {
                Section(header: Text("Placeholder")) {
                    AccountView(account: accountPreviewData)
                    AccountView(account: accountPreviewData)
                    AccountView(account: accountPreviewData)
                }
                .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                .redacted(reason: .placeholder)
            } else {
                // Display accounts grouped by ClassDescription
                ForEach(groupedAccounts, id: \.classDescription) { group in
                    Section(header: Text(group.classDescription)) {
                        ForEach(group.accounts, id: \.self) { account in
                            if query.isEmpty || account.Description.lowercased().contains(query.lowercased()) {
                                NavigationLink(destination: TransactionsView(account: account)) {
                                    AccountView(account: account)
                                }
                                .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                            }
                        }
                    }
                }
            }
            
            // Net Position View
            NetPositionView(balance: netPosition)
        }
        .navigationTitle("Accounts")
        .searchable(text: $query)
        .onAppear {
            fetchAccounts()
        }
        .refreshable {
            fetchAccounts()
        }
    }

    // Fetch and group accounts
    func fetchAccounts() {
        Task {
            accounts = await getAccounts()
            
            if !accounts.isEmpty {
                netPosition = getNetPosition(accounts: accounts)
            }
            
            groupedAccounts = groupAccountsByClassDescription(accounts)
            isLoading = false
        }
    }

    func getNetPosition(accounts: [Account]) -> Double {
        accounts.reduce(0) { total, account in
            total + account.AvailableBalance
        }
    }
}

#Preview {
    NavigationStack {
        AccountsView()
    }
}

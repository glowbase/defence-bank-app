//
//  AccountsView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI

struct DashboardView: View {
    @State private var accounts: [Account] = []
    @State private var is_loading: Bool = true
    @State private var net_position: Double = 0
    @State private var query: String = ""
    
    var body: some View {
        List {
            Section(header: Text("Payday").headerProminence(.increased)) {
                if is_loading || accounts.isEmpty {
                    PaydayView()
                        .redacted(reason: .placeholder)
                } else {
                    PaydayView()
                }
            }
            
            Section(header: Text("Accounts").headerProminence(.increased)) {
                if is_loading || accounts.isEmpty {
                    AccountView(account: accountPreviewData)
                        .redacted(reason: .placeholder)
                    AccountView(account: accountPreviewData)
                        .redacted(reason: .placeholder)
                } else {
                    ForEach(Array(accounts.enumerated()), id: \.element) { index, account in
                        if !account.Description.starts(with: "Close") && (query.isEmpty || account.Description.lowercased().contains(query.lowercased())) {
                            NavigationLink(destination: TransactionsView(account: account)) {
                                AccountView(account: account)
                            }
                            .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                        }
                    }
                }
            }
            
            Section(header: Text("Net Position").headerProminence(.increased)) {
                if is_loading || accounts.isEmpty {
                    NetPositionView(balance: 00000)
                        .redacted(reason: .placeholder)
                } else {
                    NetPositionView(balance: net_position)
                }
            }
        }
        .searchable(text: $query)
        .navigationTitle("Dashboard")
        .onAppear {
            loadAccounts()
        }
        .refreshable {
            loadAccounts()
        }
    }
    
    func loadAccounts() {
        Task {
            accounts = await getAccounts()
            net_position = getNetPosition(accounts: accounts)
            
            if accounts.isEmpty || net_position == 0 {
                loadAccounts()
            }
            
            is_loading = false
        }
    }
    
    func getNetPosition(accounts: [Account]) -> Double {
        var totalBalanace: Double = 0
        
        for account in accounts {
            totalBalanace += account.AvailableBalance
        }
        
        return totalBalanace
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}

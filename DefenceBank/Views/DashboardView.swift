//
//  AccountsView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI

struct DashboardView: View {
    @State var transactions: [Transaction] = []
    
    @State private var isLoading: Bool = true
    @State private var groupedTransactionsByCategory: [CategoryGroupedTransactions] = []
    
    var body: some View {
        List {
            Section(header: Text("Next Payday").headerProminence(.increased)) {
                if isLoading || groupedTransactionsByCategory.isEmpty {
                    PaydayView()
                        .redacted(reason: .placeholder)
                } else {
                    PaydayView()
                }
            }
            
            Section(header: Text("Weekly Transactions").headerProminence(.increased)) {
                TransactionsGraphView(transactions: $transactions)
            }
            
            Section(header: Text("Spending Habbits").headerProminence(.increased)) {
                if isLoading || groupedTransactionsByCategory.isEmpty {
                    ForEach(groupedTransactionsPreviewData, id: \.Category) { group in
                        CategoryView(group: group)
                            .redacted(reason: .placeholder)
                    }
                } else {
                    ForEach(groupedTransactionsByCategory, id: \.Category) { group in
                        if group.Category != "Miscellaneous" {
                            NavigationLink(destination: CategoryTransactionsView(category: group)) {
                                CategoryView(group: group)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Dashboard")
        .onAppear() {
            loadData()
        }
        .refreshable {
            loadData()
        }
    }
    
    func loadData() {
        Task {
            let defaultAccount = UserDefaultsManager.shared.fetch(forKey: "default_account", type: Account.self)
            
            transactions = await getTransactions(account_number: defaultAccount?.AccountNumber ?? "")
            groupedTransactionsByCategory = groupTransactionsByCategory(transactions)
            
            if groupedTransactionsByCategory.isEmpty || transactions.isEmpty {
                loadData()
            }
            
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}

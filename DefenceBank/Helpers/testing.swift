//
//  testing.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 9/1/2025.
//

import SwiftUI

struct testing: View {
    @State private var groupedTransactions: [(category: String, debitTotal: Double, creditTotal: Double, transactions: [Transaction])] = []
    @State private var isLoading = true
    
    var body: some View {
        List {
            if isLoading {
                // Placeholder while loading
                ForEach(0..<3, id: \.self) { _ in
                    Section(header: Text("Category Name").redacted(reason: .placeholder)) {
                        ForEach(0..<2, id: \.self) { _ in
                            Text("Transaction Placeholder")
                                .redacted(reason: .placeholder)
                        }
                    }
                }
            } else if groupedTransactions.isEmpty {
                // No transactions available
                Text("No transactions available.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
            } else {
                // Display grouped transactions by category
                ForEach(groupedTransactions, id: \.category) { group in
                    Section(header: categoryHeader(group: group)) {
                        ForEach(group.transactions, id: \.self) { transaction in
                            TransactionView(transaction: transaction)
                        }
                    }
                }
            }
        }
        .onAppear {
            loadTransactions()
        }
    }
    
    // Category section header with totals
    private func categoryHeader(group: (category: String, debitTotal: Double, creditTotal: Double, transactions: [Transaction])) -> some View {
        HStack {
            Text(group.category)
                .font(.headline)
            Spacer()
            VStack(alignment: .trailing) {
                Text("Debit: \(group.debitTotal, format: .currency(code: "AUD"))")
                    .foregroundColor(.red)
                    .font(.subheadline)
                Text("Credit: \(group.creditTotal, format: .currency(code: "AUD"))")
                    .foregroundColor(.green)
                    .font(.subheadline)
            }
        }
    }
    
    // Load and group transactions by category
    func loadTransactions() {
        Task {
            // Fetch transactions (replace with your API call)
            let defaultAccount = UserDefaultsManager.shared.fetch(forKey: "default_account", type: Account.self)
            let transactions = await getTransactions(account_number: defaultAccount?.AccountNumber ?? "")
            
            // Group transactions by category
            groupedTransactions = groupTransactionsByCategory(transactions)
            
            isLoading = false
        }
    }
    
    // Group transactions by category and calculate totals
    func groupTransactionsByCategory(_ transactions: [Transaction]) -> [(category: String, debitTotal: Double, creditTotal: Double, transactions: [Transaction])] {
        let grouped = Dictionary(grouping: transactions) { $0.CategoryList?.first ?? "Uncategorized" }
        
        return grouped.map { (category, transactions) in
            let debitTotal = transactions.reduce(0) { $0 + $1.DebitAmount }
            let creditTotal = transactions.reduce(0) { $0 + $1.CreditAmount }
            return (category: category, debitTotal: debitTotal, creditTotal: creditTotal, transactions: transactions)
        }.sorted { $0.category < $1.category } // Sort by category name
    }
}

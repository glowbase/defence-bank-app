//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 18/1/2023.
//

import SwiftUI

struct TransactionsView: View {
    @State var account: Account
    @State private var transactions: [Transaction] = []
    @State private var uncollected: [Uncollected] = []
    @State private var query: String = ""
    @State private var isLoading: Bool = true
    @State private var accountEditViewShowing: Bool = false
    @State private var transactionsSearchViewShowing: Bool = false
    @State private var selectedTransaction: IdentifiableTransaction? = nil
    
    var body: some View {
        List {
            if isLoading || transactions.isEmpty {
                Section(header: Text("Placeholder")) {
                    TransactionView(transaction: transactionPreviewData)
                    TransactionView(transaction: transactionPreviewData)
                }
                .redacted(reason: .placeholder)
                Section(header: Text("Placeholder")) {
                    TransactionView(transaction: transactionPreviewData)
                    TransactionView(transaction: transactionPreviewData)
                    TransactionView(transaction: transactionPreviewData)
                    TransactionView(transaction: transactionPreviewData)
                }
                .redacted(reason: .placeholder)
            } else {
                if !uncollected.isEmpty {
                    Section(header: Text("Uncollected")) {
                        ForEach(uncollected, id: \.self) { ufund in
                            UncollectedView(uncollected: ufund)
                        }
                    }
                }
                
                let filteredTransactions = filterTransactions(query: query, transactions: transactions)
                let groupedTransactions = groupTransactionsByDate(filteredTransactions)
                
                ForEach(groupedTransactions, id: \.date) { group in
                    if let parsedDate = parseDate(group.date) {
                        Section(header:
                            HStack {
                                Text(formatDate(parsedDate))
                                Spacer()
                                Text(-group.total, format: .currency(code: "AUD"))
                                    .monospacedDigit()
                            }
                        ) {
                            ForEach(group.transactions, id: \.self) { transaction in
                                let identifiableTransaction = IdentifiableTransaction(transaction: transaction)
                                
                                TransactionView(transaction: transaction)
                                    .onTapGesture {
                                        selectedTransaction = identifiableTransaction
                                    }
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $query)
        .navigationTitle(account.Description)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    transactionsSearchViewShowing = true
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.accentColor)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    accountEditViewShowing = true
                }) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.accentColor)
                }
            }
        }
        .onAppear() {
            loadData()
        }
        .refreshable {
            loadData()
        }
        .sheet(isPresented: $transactionsSearchViewShowing) {
            TransactionsSearchView()
        }
        .sheet(isPresented: $accountEditViewShowing) {
            NavigationView {
                AccountEditView(account: account)
            }
        }
        .sheet(item: $selectedTransaction) { identifiableTransaction in
            TransactionDetailView(transaction: identifiableTransaction.transaction)
        }
    }

    // Format the Date object into a user-friendly format
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE - d MMM yy"
        return formatter.string(from: date)
    }

    // Load transactions for the specified account number
    func loadData() {
        Task {
            transactions = await getTransactions(account_number: account.AccountNumber)
            uncollected = await getUncollected(account_number: account.AccountNumber)
            
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        TransactionsView(account: accountPreviewData)
    }
}

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
                Section(header: Text("Uncollected")) {
                    ForEach(uncollected, id: \.self) { ufund in
                        UncollectedView(uncollected: ufund)
                    }
                }
                
                ForEach(groupedTransactions(), id: \.date) { group in
                    if let parsedDate = parseDate(group.date) {
                        Section(header: Text(formatDate(parsedDate))) {
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
                        .padding([.trailing], 8)
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
            AccountEditView(account: account)
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

    // Filter the transactions based on the search query
    func filteredTransactions() -> [Transaction] {
        if query.isEmpty {
            return transactions
        }
        
        return transactions.filter { transaction in
            (transaction.MerchantName ?? transaction.Description ?? transaction.LongDescription ?? "").lowercased().contains(query.lowercased())
        }
    }

    // Group the transactions by date (ignoring the time part) and apply search filtering
    func groupedTransactions() -> [(date: String, transactions: [Transaction])] {
        // Filter transactions based on the search query
        let filtered = filteredTransactions()

        // Group by date (ignoring time)
        let grouped = Dictionary(grouping: filtered) { transaction -> String in
            if let parsedDate = parseDate(transaction.CreateDate) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"  // Only the date part (no time)
                return dateFormatter.string(from: parsedDate)
            }
            return ""  // Return an empty string for invalid dates
        }

        // Sort the groups by date and reverse the order (from most recent to oldest)
        return grouped.keys.sorted().reversed().map { date in
            (date: date, transactions: grouped[date]!)
        }
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

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransactionsView(account: accountPreviewData)
        }
    }
}

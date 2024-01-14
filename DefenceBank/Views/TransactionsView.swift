//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 18/1/2023.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var data = AppDataModel()
    @State private var searchText = ""
    
    let account: Account
    
    var body: some View {
        List {
            ForEach(Array(transactionResults.enumerated()), id: \.element) { index, transaction in
                TransactionView(transaction: transaction)
            }
        }
        .searchable(text: $searchText)
        .navigationTitle(account.Description)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                if isPreview {
                    self.data.transactions = transactionsPreviewData
                } else {
                    self.data.transactions = getTransactions(account_number: account.AccountNumber)
                }
            }
        }
    }
    
    var transactionResults: [Transaction] {
        if searchText.isEmpty {
            return data.transactions
        } else {
            return data.transactions.filter {
                ($0.MerchantName?.lowercased() ?? $0.LongDescription?.lowercased())?.contains(searchText.lowercased()) ?? false
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        return data
    }()
    
    static var previews: some View {
        NavigationStack {
            TransactionsView(account: accountPreviewData)
                .environmentObject(data)
        }
    }
}

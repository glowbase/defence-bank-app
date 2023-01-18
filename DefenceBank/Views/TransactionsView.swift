//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 18/1/2023.
//

import SwiftUI

struct TransactionsView: View {
    let account: Account
    @State var transactions: [Transaction] = []
    
    var body: some View {
        VStack() {
            Text("Testing")
            List() {
                ForEach(Array(transactions.enumerated()), id: \.element) { index, transaction in
                    Text(transaction.LongDescription ?? "No Description")
                }
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.global(qos: .background).async {
                transactions = getTransactions(account_number: account.AccountNumber)
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView(account: accountPreviewData)
    }
}

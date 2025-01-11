//
//  CategoryTransactionsView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 10/1/2025.
//

import SwiftUI

struct CategoryTransactionsView: View {
    @State var category: CategoryGroupedTransactions?
    
    var body: some View {
        List {
            ForEach(category?.Transactions ?? [], id:\.ImmutableTransactionId) { transaction in
                TransactionView(transaction: transaction)
            }
        }
        .navigationTitle(category?.Category ?? "")
    }
}

#Preview {
    CategoryTransactionsView()
}

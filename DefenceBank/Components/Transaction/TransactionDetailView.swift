//
//  TransactionDetailView.swift
//  DefenceBank
//
//  Created by Cooper on 15/8/2023.
//

import SwiftUI

struct TransactionDetailView: View {
    var transaction: Transaction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Transaction Details")
                .font(.largeTitle)
                .bold()
                .padding()

            // Displaying Merchant Name and Description
            Text("Merchant: \(transaction.MerchantName ?? "Unknown")")
                .font(.title2)
                .padding(.top)
            
            Text("Description: \(transaction.Description ?? "No Description")")
                .font(.body)
            
            Divider()

            // Displaying Amount and Balance
            Text("Amount: \(formatAmount(transaction.DebitAmount > 0 ? transaction.DebitAmount : transaction.CreditAmount))")
                .font(.title)
                .padding(.top)
            
            Text("Balance: \(formatAmount(transaction.Balance))")
                .font(.body)
            
            // Display Transaction Date
            Text("Transaction Date: \(formatDate(parseDate(transaction.CreateDate) ?? Date()))")
                .font(.body)
            
            Spacer()
        }
        .padding()
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
}

#Preview {
    TransactionDetailView(transaction: transactionPreviewData)
}

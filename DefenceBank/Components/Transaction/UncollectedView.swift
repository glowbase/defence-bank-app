//
//  UncollectedView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 4/1/2025.
//

import SwiftUI

struct UncollectedView: View {
    var uncollected: Uncollected
    
    var body: some View {
        HStack {
            Image(systemName: "photo.fill")
                .frame(width: 50, height: 50)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading) {
                // Merchant Name
                Text(uncollected.MerchantName)
                    .font(.body)
                    .bold()
                
                // Description
                Text(uncollected.Description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()  // This pushes the amount to the right side
            
            // Display Debit or Credit amount
            VStack(alignment: .trailing) {
                if uncollected.DebitAmount > 0 {
                    // Show debit amount in red
                    Text("Debit")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Text(formatAmount(uncollected.DebitAmount))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                        .monospaced()
                } else if uncollected.CreditAmount > 0 {
                    // Show credit amount in green
                    Text("Credit")
                        .font(.footnote)
                        .foregroundColor(.green)
                    Text(formatAmount(uncollected.CreditAmount))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                        .monospaced()
                } else {
                    // If neither debit nor credit, show a placeholder
                    Text("N/A")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 8)
    }

    // Format the amount as currency with a proper symbol
    func formatAmount(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

struct UncollectedView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: transactionPreviewData)
            .padding()
    }
}

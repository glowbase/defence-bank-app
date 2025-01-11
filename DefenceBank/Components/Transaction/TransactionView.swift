//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 21/1/2023.
//

import SwiftUI

struct TransactionView: View {
    var transaction: Transaction
    
    var body: some View {
        HStack {
            // Display the merchant's logo with rounded corners (if available)
            if let imageUrl = transaction.MerchantLogo, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image(systemName: "photo.fill")
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Fallback if no image is available
                Image(systemName: "photo.fill")
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            VStack(alignment: .leading) {
                // Merchant Name - if "Round Up" is found in the description, split it
                if let longDescription = transaction.LongDescription, longDescription.contains("Round Up") {
                    Text("Round Up")
                        .font(.body)
                        .bold()
                } else {
                    // Default merchant name
                    Text(transaction.MerchantName ?? transaction.LongDescription ?? "Unknown Merchant")
                        .font(.body)
                        .bold()
                }
                
                // Description - if "Round Up" is found, take the part after the ":"
                if let longDescription = transaction.LongDescription, longDescription.contains("Round Up") {
                    let parts = longDescription.split(separator: ":")
                    Text(parts.count > 1 ? parts.last?.trimmingCharacters(in: .whitespaces) ?? "" : "No description")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    // Default description
                    Text(transaction.Description ?? "No description available")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()  // This pushes the amount to the right side
            
            // Display Debit or Credit amount
            VStack(alignment: .trailing) {
                if transaction.DebitAmount > 0 {
                    // Show debit amount in red
                    Text("Debit")
                        .font(.footnote)
                        .foregroundColor(.red)
                    Text(formatAmount(transaction.DebitAmount))
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.red)
                        .monospaced()
                } else if transaction.CreditAmount > 0 {
                    // Show credit amount in green
                    Text("Credit")
                        .font(.footnote)
                        .foregroundColor(.green)
                    Text(formatAmount(transaction.CreditAmount))
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

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: transactionPreviewData)
            .padding()
    }
}

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
        HStack() {
            AsyncImage(url: URL(string: transaction.MerchantLogo ?? "")) { image in
                image.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 50, height: 50)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(25)
            .padding([.bottom], 12)
            
            HStack() {
                Text(transaction.MerchantName ?? transaction.LongDescription ?? "")
                
                Spacer()
                
                if (transaction.DebitAmount == 0.0) {
                    Text(transaction.CreditAmount, format: .currency(code: "AUD"))
                        .foregroundColor(.green)
                } else {
                    Text(transaction.DebitAmount, format: .currency(code: "AUD"))
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: transactionPreviewData)
    }
}

//
//  TransactionView.swift
//  DefenceBank
//
//  Created by Cooper on 21/1/2023.
//

import SwiftUI

struct TransactionView: View {
    @State private var showingSheet = false
    
    var transaction: Transaction
    
    var body: some View {
        HStack() {
            AsyncImage(url: URL(string: transaction.MerchantLogo ?? "")) { image in
                image.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 50, height: 50)
            .cornerRadius(10)
            
            HStack() {
                VStack() {
                    Text((transaction.MerchantName ?? transaction.LongDescription ?? "").decode)
                        .frame(width: .infinity, height: 18)
                        .truncationMode(.tail)
                }
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
        .contentShape(Rectangle())
        .onTapGesture {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            TransactionSheetView(transaction: transaction)
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(transaction: transactionPreviewData)
    }
}

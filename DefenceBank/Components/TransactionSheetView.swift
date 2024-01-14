//
//  TransactionSheetView.swift
//  DefenceBank
//
//  Created by Cooper on 15/8/2023.
//

import SwiftUI

struct TransactionSheetView: View {
    var transaction: Transaction
    
    var body: some View {
        NavigationView {
            List {
                VStack {
                    HStack {
                        AsyncImage(url: URL(string: transaction.MerchantLogo ?? "")) { image in
                            image.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(10)
                    }
                    
                    if (transaction.DebitAmount == 0.0) {
                        Text(transaction.CreditAmount, format: .currency(code: "AUD"))
                            .font(.largeTitle)
                            .foregroundColor(.green)
                    } else {
                        Text(transaction.DebitAmount, format: .currency(code: "AUD"))
                            .font(.largeTitle)
                            .foregroundColor(.red)
                    }
                }
                Section(header: Text("Location").headerProminence(.increased)) {
                    
                }
            }
            .listStyle(.insetGrouped)
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    TransactionSheetView(transaction: transactionPreviewData)
}

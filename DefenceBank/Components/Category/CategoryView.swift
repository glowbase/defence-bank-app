//
//  CategoryView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 9/1/2025.
//

import SwiftUI

struct CategoryView: View {
    @State var group: CategoryGroupedTransactions
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(group.Category)
                    .bold()
                Text("\(group.Transactions.count) transactions.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("\(group.Total, format: .currency(code: "AUD"))")
                    .foregroundColor(.red)
                    .monospaced()
            }
        }
    }
}

#Preview {
    CategoryView(group: groupedTransactionPreview)
        .padding()
}

//
//  CardQuickActionsView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct CardQuickActionsView: View {
    @State var card: Card
    
    var body: some View {
        HStack {
            VStack {
                Image(systemName: "lock")
                    .frame(width: 50, height: 50)
                    .font(.system(size: 20))
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                Text("Lock")
            }
            Spacer()
            VStack {
                Image(systemName: "number.square")
                    .frame(width: 50, height: 50)
                    .font(.system(size: 20))
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                Text("Change PIN")
            }
            Spacer()
            VStack {
                Image(systemName: "creditcard.and.123")
                    .frame(width: 50, height: 50)
                    .font(.system(size: 20))
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 50))
                Text("Details")
            }
        }
        .padding([.leading, .trailing], 50)
    }
}

#Preview {
    CardQuickActionsView(card: cardPreviewData)
        .padding()
}

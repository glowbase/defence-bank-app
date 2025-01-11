//
//  AccountRowView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 1/1/2025.
//

import SwiftUI

struct AccountView: View {
    var account: Account
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(account.Description)
                            .font(.body)
                            .bold()
                        Text(account.AccountNumber)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.AvailableBalance, format: .currency(code: "AUD"))
                            .bold()
                            .monospaced()
                    }
                }
            }
            .foregroundColor(.white)
        }
        .padding([.top, .bottom], 2)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: accountPreviewData)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.red.gradient)
            .cornerRadius(8)
            .padding()
    }
}

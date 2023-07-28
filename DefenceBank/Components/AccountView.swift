//
//  AccountView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI

struct AccountView: View {
    @State private var showTransactionsView: Bool = false
    var account: Account
    
    var body: some View {
        ZStack() {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(account.Description)
                            .font(.title3)
                        Text(account.AccountNumber)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.AvailableBalance, format: .currency(code: "AUD"))
                            .bold()
                    }
                }
            }
            .foregroundColor(.white)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: accountPreviewData)
    }
}

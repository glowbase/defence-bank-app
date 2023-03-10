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
            NavigationLink(
                destination: TransactionsView(account: account),
                isActive: $showTransactionsView
            ) { EmptyView() }
            
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
                    Image(systemName: "chevron.right")
                }
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Available")
                            .foregroundColor(.white.opacity(0.8))
                        Text("Balance")
                            .foregroundColor(.white.opacity(0.8))
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 4) {
                        Text(account.AvailableBalance, format: .currency(code: "AUD"))
                            .bold()
                        Text(account.CurrentBalance, format: .currency(code: "AUD"))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
            .padding()
            .foregroundColor(.white)
            .background(
                LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .onTapGesture {
                self.showTransactionsView = true
            }
        }
        .padding([.bottom], 10)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: accountPreviewData)
    }
}

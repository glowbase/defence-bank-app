//
//  AccountView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI

struct AccountView: View {
    var account: Account
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(account.Description)
                    .font(.system(size: 26))
                HStack {
                    Text(account.AccountNumber)
                    Text("·")
                    Text(account.ClassDescription)
                }
                .font(.system(size: 18))
            }
            Spacer()
            Text(account.CurrentBalance, format: .currency(code: "AUD"))
                .font(.system(size: 26))
                .bold()
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(account: accountPreviewData)
    }
}

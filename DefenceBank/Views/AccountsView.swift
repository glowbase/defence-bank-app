//
//  AccountsView.swift
//  DefenceBank
//
//  Created by Cooper on 15/1/2023.
//

import SwiftUI

struct AccountsView: View {
    @StateObject var data = AppDataModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(Array(data.accounts.enumerated()), id: \.element) { index, account in
                    AccountView(account: account)
                }
            }
            .padding()
            .navigationTitle("Accounts")
        }
        .environmentObject(data)
    }
}

struct AccountsView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        data.accounts = accountsPreviewData
        
        return data
    }()
    
    static var previews: some View {
        AccountsView()
            .environmentObject(data)
    }
}

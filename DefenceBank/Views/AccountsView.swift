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
            List {
                Section(header: Text("Accounts").headerProminence(.increased)) {
                    if data.accounts.count > 0 {
                        ForEach(Array(data.accounts.enumerated()), id: \.element) { index, account in
                            NavigationLink(destination: TransactionsView(account: account)) {
                                AccountView(account: account)
                            }
                        }
                        .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                    } else {
                        let placeholderAccount = Account(
                            AccountNumber: "20392984",
                            Description: "Everyday",
                            CurrentBalance: 394.64,
                            AvailableBalance: 375.25,
                            ClassDescription: "Everyday Access"
                        )
                    
                        
                        NavigationLink(destination: EmptyView()) {
                            AccountView(account: placeholderAccount)
                        }
                        .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                        .redacted(reason: .placeholder)
                        
                        NavigationLink(destination: EmptyView()) {
                            AccountView(account: placeholderAccount)
                        }
                        .listRowBackground(LinearGradient(gradient: Gradient(colors: [.red, .accentColor]), startPoint: .leading, endPoint: .trailing))
                        .redacted(reason: .placeholder)
                    }
                }
                .listRowInsets(EdgeInsets(top: 15, leading: 20, bottom: 15, trailing: 15))
                .scrollContentBackground(.hidden)
            }
            .environmentObject(data)
            .listStyle(.insetGrouped)
            .navigationTitle("Dashboard")
        }
    }
}

struct AccountsView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        data.accounts = accountsPreviewData
        
        return data
    }()
    
    static var previews: some View {
        AccountsView(data: data)
            .environmentObject(data)
    }
}

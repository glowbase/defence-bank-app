//
//  TransactionEditView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 3/1/2025.
//

import SwiftUI

struct AccountEditView: View {
    @State var account: Account
    
    @State private var accountName: String = ""
    @State private var showConfirmation = false
    @State private var isDefault: Bool = false
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            Section(header: Text("Rename Account").headerProminence(.standard)) {
                TextField(text: $accountName, label: {
                    Text("\(account.Description)")
                })
            }
            
            Section(header: Text("Default Account").headerProminence(.standard)) {
                Toggle(isOn: $isDefault) {
                    Text("Default Account")
                }
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .onChange(of: isDefault) { newValue in
                    if newValue {
                        UserDefaultsManager.shared.save(account, forKey: "default_account")
                    } else {
                        // Handle the logic for when the account is no longer default
                        // For example, clear the saved default account from UserDefaults
                        UserDefaultsManager.shared.delete(forKey: "default_account")
                    }
                }
            }
        }
        .navigationTitle("Edit Account")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Logic to save account changes via API
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
            }
        }
        .onAppear() {
            let defaultAccount = UserDefaultsManager.shared.fetch(forKey: "default_account", type: Account.self)
            isDefault = (defaultAccount == account)
        }
    }
}


#Preview {
    NavigationStack {
        AccountEditView(account: accountPreviewData)
    }
}

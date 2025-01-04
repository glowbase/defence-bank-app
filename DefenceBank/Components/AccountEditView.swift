//
//  TransactionEditView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 3/1/2025.
//

import SwiftUI

struct AccountEditView: View {
    @State var account: Account
    
    var body: some View {
        List {
            Section(header: Text("Name")) {
                
            }
            
            Section(header: Text("PayID")) {
                
            }
            
            Section(header: Text("Details")) {
                
            }
            
            Section(header: Text("Year to Date")) {
                
            }
            
            Section(header: Text("Financial Year")) {
                
            }
        }
    }
}

#Preview {
    AccountEditView(account: accountPreviewData)
}

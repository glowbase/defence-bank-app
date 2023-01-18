//
//  AccountsTotalView.swift
//  DefenceBank
//
//  Created by Cooper on 17/1/2023.
//

import SwiftUI

struct AccountsTotalView: View {
    @StateObject var data = AppDataModel()
    
    var body: some View {
        if data.accountsTotal != 0.0 {
            HStack() {
                Text("Total")
                Spacer()
                Text(data.accountsTotal, format: .currency(code: "AUD"))
                    .font(.title2)
                    .bold()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8)
        }
    }
}

struct AccountsTotalView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        data.accounts = accountsPreviewData
        
        return data
    }()
    
    static var previews: some View {
        AccountsTotalView(data: data)
            .environmentObject(data)
    }
}

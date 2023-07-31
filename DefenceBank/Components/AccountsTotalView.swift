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
        HStack() {
            Text("Net Position")
            Spacer()
            Text(data.accountsTotal, format: .currency(code: "AUD"))
                .font(.title3)
                .bold()
        }
    }
}

struct AccountsTotalView_Previews: PreviewProvider {
    static let data: AppDataModel = {
        let data = AppDataModel()
        
        data.accounts = accountsPreviewData
        data.accountsTotal = 1039.19
        
        return data
    }()
    
    static var previews: some View {
        AccountsTotalView(data: data)
            .environmentObject(data)
    }
}

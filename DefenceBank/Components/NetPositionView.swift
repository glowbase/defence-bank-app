//
//  NetPositionView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 2/1/2025.
//

import SwiftUI

struct NetPositionView: View {
    @State var balance: Double
    
    var body: some View {
        HStack {
            Text(balance, format: .currency(code: "AUD"))
                .font(.title2)
            Spacer()
        }
        .padding([.top, .bottom], 4)
    }
}

struct NetPositionView_Previews: PreviewProvider {
    static var previews: some View {
        NetPositionView(balance: 30293)
            .padding()
    }
}

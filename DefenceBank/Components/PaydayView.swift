//
//  PaydayView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 2/1/2025.
//

import SwiftUI

struct PaydayView: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Tomorrow")
                    .bold()
                Spacer()
                Image(systemName: "pencil")
                    .bold()
                    .foregroundColor(.red)
                    .onTapGesture {
                        showSheet.toggle()
                    }
            }

            ProgressView(value: 0.5, total: 1)
                .progressViewStyle(LinearProgressViewStyle(tint: .red))
                .scaleEffect(x: 1, y: 4, anchor: .center)
                .frame(height: 15)
                .cornerRadius(10)
                .padding([.bottom], 4)
            
            HStack {
                Text("Next Pay: Thu 16 Jan, 2025")
                Spacer()
                Text("Fortnightly")
            }
            .font(.footnote)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $showSheet) {
            PaydayEditView()
                .presentationDetents([.height(280)])
        }
    }
}

struct PaydayView_Previews: PreviewProvider {
    static var previews: some View {
        PaydayView()
            .padding()
    }
}

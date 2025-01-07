//
//  PaydayEditView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct PaydayEditView: View {
    @State private var nextPayday: Date = Date()
    @State private var selectedOption: String = "Fortnightly"
    
    let options = ["Weekly", "Fortnightly", "Monthly"]
    
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 42))
                .padding(.top, 24)
            Text("Your Pay Cycle")
                .bold()
                .font(.title3)
                .padding(.top, 10)
            
            List {
                DatePicker("Next Payday", selection: $nextPayday, displayedComponents: .date)
                    .listRowBackground(Color.clear)
                Picker("Pay Cycle", selection: $selectedOption) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollDisabled(true)
        }
        .navigationBarTitle("Edit Payday", displayMode: .inline)
    }
}
#Preview {
    PaydayEditView()
}

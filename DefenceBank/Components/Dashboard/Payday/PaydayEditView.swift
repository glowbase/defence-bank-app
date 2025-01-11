//
//  PaydayEditView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct PaydayEditView: View {
    @Binding var paydayCountdown: PaydayCountdown?  // Binding to the payday data
    
    @State private var nextPayday: Date = Date()
    @State private var frequency: String = "Fortnightly"
    
    @Environment(\.presentationMode) var presentationMode
    
    let options = ["Weekly", "Fortnightly", "Monthly"]
    
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .font(.system(size: 42))
            Text("Your Pay Cycle")
                .bold()
                .font(.title3)
                .padding(.top, 10)
            
            List {
                DatePicker("Next Payday", selection: $nextPayday, displayedComponents: .date)
                    .listRowBackground(Color.clear)
                    .onChange(of: nextPayday) { newValue in
                        savePaydayData()  // Save data when the date is changed
                    }
                
                Picker("Pay Cycle", selection: $frequency) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
                .listRowBackground(Color.clear)
                .onChange(of: frequency) { newValue in
                    savePaydayData()  // Save data when the frequency is changed
                }
            }
            .scrollDisabled(true)
            .scrollContentBackground(.hidden)
        }
        .onAppear {
            if let currentPayday = paydayCountdown {
                self.nextPayday = currentPayday.NextPayday
                self.frequency = currentPayday.Frequency
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                }
            }
        }
    }
    
    // Function to save the payday data to UserDefaults
    private func savePaydayData() {
        let updatedPayday = PaydayCountdown(NextPayday: nextPayday, Frequency: frequency)
        paydayCountdown = updatedPayday
        UserDefaultsManager.shared.save(updatedPayday, forKey: "paydayCountdown")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

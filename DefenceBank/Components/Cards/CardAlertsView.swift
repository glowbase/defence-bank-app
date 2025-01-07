//
//  CardAlertsView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct CardAlertView: View {
    @State var slider: SliderItem
    
    @State private var paywaveThresholdTextfield: String = ""
    @State private var paywaveSelectedThreshold: String = ""
    @State private var paywaveSelectedOption: String = ""
    @State private var paywaveOccured: Bool = false
    @State private var paywaveExceeded: Bool = false
    
    @State private var atmThresholdTextfield: String = ""
    @State private var atmSelectedThreshold: String = ""
    @State private var atmSelectedOption: String = ""
    @State private var atmOccured: Bool = false
    @State private var atmExceeded: Bool = false
    
    @State private var creditThresholdTextfield: String = ""
    @State private var creditSelectedThreshold: String = ""
    @State private var creditSelectedOption: String = ""
    @State private var creditOccured: Bool = false
    @State private var creditExceeded: Bool = false
    
    @State private var eftposThresholdTextfield: String = ""
    @State private var eftposSelectedThreshold: String = ""
    @State private var eftposSelectedOption: String = ""
    @State private var eftposOccured: Bool = false
    @State private var eftposExceeded: Bool = false
    
    let options = ["Daily", "Weekly", "Fortnightly", "Monthly", "Quarterly", "Half Year", "Yearly"]
    
    var body: some View {
        List {
            ZStack {
                Image(slider.Background)
                    .resizable()
                    .frame(width: nil, height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                HStack {
                    Text("xxxx")
                    Text("xxxx")
                    Text("xxxx")
                    Text("\(String(slider.Card.Number.suffix(4)))")
                        .monospaced()
                }
                .shadow(color: .black, radius: 3, x: 1, y: 1)
                .foregroundColor(.white)
                .padding(.top, 45)
                .font(.title2)
                .bold()
            }
            .listRowBackground(Color.clear)
            
            Section(header: Text("Pay Wave").headerProminence(.increased)) {
                Toggle(isOn: $paywaveOccured, label: { Text("Transaction Occured") })
                Toggle(isOn: $paywaveExceeded, label: { Text("Threshold Exceeded") })
                
                if paywaveExceeded {
                    HStack {
                        Text("$")
                        TextField("Threshold", text: $paywaveThresholdTextfield)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Frequency", selection: $paywaveSelectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
            }
            
            Section(header: Text("ATM Withdrawl").headerProminence(.increased)) {
                Toggle(isOn: $atmOccured, label: { Text("Transaction Occured") })
                Toggle(isOn: $atmExceeded, label: { Text("Threshold Exceeded") })
                
                if atmExceeded {
                    HStack {
                        Text("$")
                        TextField("Threshold", text: $atmThresholdTextfield)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Frequency", selection: $atmSelectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
            }
            
            Section(header: Text("Credit Card").headerProminence(.increased)) {
                Toggle(isOn: $creditOccured, label: { Text("Transaction Occured") })
                Toggle(isOn: $creditExceeded, label: { Text("Threshold Exceeded") })
                
                if creditExceeded {
                    HStack {
                        Text("$")
                        TextField("Threshold", text: $creditThresholdTextfield)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Frequency", selection: $creditSelectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
            }
            
            Section(header: Text("EFTPOS").headerProminence(.increased)) {
                Toggle(isOn: $eftposOccured, label: { Text("Transaction Occured") })
                Toggle(isOn: $eftposExceeded, label: { Text("Threshold Exceeded") })
                
                if eftposExceeded {
                    HStack {
                        Text("$")
                        TextField("Threshold", text: $eftposThresholdTextfield)
                            .keyboardType(.decimalPad)
                    }
                    Picker("Frequency", selection: $eftposSelectedOption) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                        }
                    }
                }
            }
        }
        .navigationTitle("Card Alerts")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CardAlertView(slider: cardSliderPreviewData)
    }
}

//
//  CardControlView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct CardControlView: View {
    @State var slider: SliderItem
    
    @State private var paywaveAustralia: Bool = false
    @State private var paywaveInternational: Bool = false
    
    @State private var onlineAustralia: Bool = false
    @State private var onlineInternational: Bool = false
    
    @State private var instoreAustralia: Bool = false
    @State private var instoreInternational: Bool = false
    
    @State private var atmAustralia: Bool = false
    @State private var atmInternational: Bool = false
    
    @State private var digitalAustralia: Bool = false
    @State private var digitalInternational: Bool = false
    
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
            
            Section(header: Text("payWave").headerProminence(.increased), footer: Text("Block only contactless purchases on the plastic card.")) {
                Toggle(isOn: $paywaveAustralia, label: { Text("Australia") })
                Toggle(isOn: $paywaveInternational, label: { Text("International") })
                
            }
            Section(header: Text("Online Purchases").headerProminence(.increased), footer: Text("Block all card-not-present purchases.")) {
                Toggle(isOn: $onlineAustralia, label: { Text("Australia") })
                Toggle(isOn: $onlineInternational, label: { Text("International") })
            }
            Section(header: Text("In-Store Purchases").headerProminence(.increased), footer: Text("Block all card-present purchases on the plastic card.")) {
                Toggle(isOn: $instoreAustralia, label: { Text("Australia") })
                Toggle(isOn: $instoreInternational, label: { Text("International") })
            }
            Section(header: Text("ATM Withdrawls").headerProminence(.increased), footer: Text("Block domestic and international ATM withdrawls on the card.")) {
                Toggle(isOn: $atmAustralia, label: { Text("Australia") })
                Toggle(isOn: $atmInternational, label: { Text("International") })
            }
            Section(header: Text("Digital Wallet").headerProminence(.increased), footer: Text("Block only contactless purchases from a mobile device.")) {
                Toggle(isOn: $digitalAustralia, label: { Text("Australia") })
                Toggle(isOn: $digitalInternational, label: { Text("International") })
            }
        }
        .navigationTitle("Card Controls")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        CardControlView(slider: cardSliderPreviewData)
    }
}

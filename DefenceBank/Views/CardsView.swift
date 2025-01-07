//
//  CardsView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 5/1/2025.
//

import SwiftUI

struct CardsView: View {
    @State private var isLoading: Bool = true
    @State private var cards: [Card] = []
    @State private var items: [SliderItem] = []
    @State private var activeId: UUID? = nil
    
    @State private var _aid: UUID? = nil
    @State private var i: [SliderItem] = cardsPreviewData
    
    var body: some View {
        VStack {
            if isLoading || cards.isEmpty {
                CardSlider(data: $i, activeId: $_aid) { $item in
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.gray.gradient)
                            .frame(width: nil, height: 220)
                        HStack {
                            Text("xxxx")
                            Text("xxxx")
                            Text("xxxx")
                            Text("xxxx")
                        }
                        .foregroundColor(.white)
                        .padding(.top, 45)
                        .font(.title2)
                        .bold()
                    }
                } titleContent: { $item in
                    Text(item.Title)
                        .font(.title2)
                        .padding(.bottom, 8)
                        .bold()
                    
                    Text(item.SubTitle)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                        .font(.footnote)
                        .bold()
                }
                .safeAreaPadding([.horizontal, .top], 35)
                .redacted(reason: .placeholder)
                
                CardQuickActionsView(card: cardPreviewData)
                    .padding([.top, .bottom], 12)
                    .redacted(reason: .placeholder)
                
                List {
                    CardControlGroupView(image: "switch.2", title: "Card Controls")
                    CardControlGroupView(image: "creditcard.trianglebadge.exclamationmark", title: "Lost or Stolen Card")
                    CardControlGroupView(image: "bell.badge", title: "Card Alerts")
                }
                .scrollDisabled(true)
                .redacted(reason: .placeholder)
            } else {
                CardSlider(data: $items, activeId: $activeId) { $item in
                    CardView(slider: item, placeholder: isLoading)
                } titleContent: { $item in
                    Text(item.Title)
                        .font(.title2)
                        .padding(.bottom, 8)
                        .bold()
                    
                    Text(item.SubTitle)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 10)
                        .font(.footnote)
                        .bold()
                }
                .safeAreaPadding([.horizontal, .top], 35)
                
                if let selectedCard = items.first(where: { $0.id == activeId }) {
                    CardQuickActionsView(card: selectedCard.Card)
                        .padding([.top, .bottom], 16)
                    
                    List {
                        NavigationLink(destination: CardControlView(slider: selectedCard)) {
                            CardControlGroupView(image: "switch.2", title: "Card Controls", card: selectedCard.Card)
                        }
                        NavigationLink(destination: EmptyView()) {
                            CardControlGroupView(image: "creditcard.trianglebadge.exclamationmark", title: "Lost or Stolen Card", card: selectedCard.Card)
                        }
                        NavigationLink(destination: CardAlertView(slider: selectedCard)) {
                            CardControlGroupView(image: "bell.badge", title: "Card Alerts", card: selectedCard.Card)
                        }
                        
                    }
                    .scrollDisabled(true)
                }
            }
        }
        .onAppear() {
            Task {
                cards = await getCards()
                
                items = cards.map {card in
                    var background = "default"
                    
                    if card.Type == "VISA DEBIT - CAMO ARMY GREEN" {
                        background = "army"
                    } else if card.Type == "VISA DEBIT - RAAF" {
                        background = "raaf"
                    }
                    
                    return SliderItem(Background: background, Title: card.LinkedAccounts[0].Name, SubTitle: card.LinkedAccounts[0].AccountNumber, Card: card)
                }
                
                if !items.isEmpty {
                    activeId = items.first?.id
                }
                
                isLoading = false
            }
        }
    }
}

#Preview {
    CardsView()
}

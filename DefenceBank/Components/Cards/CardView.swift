//
//  CardView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct CardView: View {
    @State var slider: SliderItem
    @State var placeholder: Bool
    
    var body: some View {
        if placeholder {
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
            .redacted(reason: .placeholder)
        } else {
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
        }
    }
}

#Preview {
    CardView(slider: cardSliderPreviewData, placeholder: true)
        .padding()
}

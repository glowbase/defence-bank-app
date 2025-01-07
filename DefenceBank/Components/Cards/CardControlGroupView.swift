//
//  CardControlGroup.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 7/1/2025.
//

import SwiftUI

struct CardControlGroupView: View {
    @State var image: String = "photo.fill"
    @State var title: String = "Placeholder"
    @State var card: Card = cardPreviewData
    @State var destination: AnyView = AnyView(EmptyView())
    
    var body: some View {
        HStack {
            Image(systemName: image)
                .frame(width: 50, height: 50)
                .font(.system(size: 20))
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(title)
                .padding(.leading, 8)
            Spacer()
        }
    }
}

#Preview {
    CardControlGroupView(destination: AnyView(EmptyView()))
        .padding()
}

//
//  CustomPagingSlider.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 5/1/2025.
//

import SwiftUI

struct CardSlider<Content: View, TitleContent: View, Item: RandomAccessCollection>: View where Item: MutableCollection, Item.Element: Identifiable {
    @Binding var data: Item
    @Binding var activeId: UUID?
    
    @ViewBuilder var content: (Binding<Item.Element>) -> Content
    @ViewBuilder var titleContent: (Binding<Item.Element>) -> TitleContent
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(.horizontal) {
                HStack(spacing: 10) {
                    ForEach($data) { item in
                        VStack(spacing: 0) {
                            titleContent(item)
                                .frame(maxWidth: .infinity)
                            content(item)
                        }
                        .containerRelativeFrame(.horizontal)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.visible)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeId)
            
            PagingControl(numberOfPages: data.count, activePage: activePage) { value in
                if let index = value as? Item.Index, data.indices.contains(index) {
                    if let id = data[index].id as? UUID {
                        withAnimation(.snappy(duration: 0.35, extraBounce: 0)) {
                            activeId = id
                        }
                    }
                }
            }
        }
    }
    
    var activePage: Int {
        if let index = data.firstIndex(where: { $0.id as? UUID == activeId }) as? Int {
            return index
        }
        
        return 0
    }
}

struct PagingControl: UIViewRepresentable {
    var numberOfPages: Int
    var activePage: Int
    var onPageChange: (Int) -> ()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(onPageChange: onPageChange)
    }
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        
        view.currentPage = activePage
        view.numberOfPages = numberOfPages
        view.backgroundStyle = .prominent
        view.currentPageIndicatorTintColor = UIColor(Color.primary)
        view.pageIndicatorTintColor = UIColor.placeholderText
        view.addTarget(context.coordinator, action: #selector(Coordinator.onPageUpdate(control:)), for: .valueChanged)
        
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.numberOfPages = numberOfPages
        uiView.currentPage = activePage
    }
    
    class Coordinator: NSObject {
        var onPageChange: (Int) -> ()
        
        init(onPageChange: @escaping (Int) -> Void) {
            self.onPageChange = onPageChange
        }
        
        @objc
        func onPageUpdate(control: UIPageControl) {
            onPageChange(control.currentPage)
        }
    }
}

#Preview {
    CardsView()
}

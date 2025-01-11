//
//  ContentView.swift
//  DefenceBank
//
//  Created by Cooper Beltrami on 5/1/2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        // TabView to create the bottom navigation bar with 3 options
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "house.fill")
            }
            NavigationStack {
                AccountsView()
            }
                .tabItem {
                    Label("Accounts", systemImage: "rectangle.stack")
                }
            CardsView()
                .tabItem {
                    Label("Cards", systemImage: "creditcard.fill")
                }
            EmptyView()
                .tabItem {
                    Label("Payments", systemImage: "dollarsign.arrow.trianglehead.counterclockwise.rotate.90")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "person.crop.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}

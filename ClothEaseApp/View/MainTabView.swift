//
//  MainTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeTabView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SalesHistoryView()
                .tabItem {
                    Label("Sales", systemImage: "chart.bar")
                }

            CustomerListView()
                .tabItem {
                    Label("Customers", systemImage: "person.3")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "gearshape")
                }
        }
    }
}

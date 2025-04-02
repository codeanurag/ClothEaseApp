//
//  MainTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var viewModel = SalesViewModel()

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
                .badge(viewModel.sales.count)

            CustomerListView()
                .tabItem {
                    Label("Customers", systemImage: "person.3")
                }
                .badge(viewModel.customers.count)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "gearshape")
                }
        }
        .environmentObject(viewModel) // share across tabs
    }
}

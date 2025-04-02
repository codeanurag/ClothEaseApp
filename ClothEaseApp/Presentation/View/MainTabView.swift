//
//  MainTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var repo = LocalSalesRepository()

    @State private var selectedTab = 0
    @State private var salesBadge: Int = 0
    @State private var customersBadge: Int = 0

    var body: some View {
        let addSaleUseCase = AddSaleUseCase(repository: repo)
        let updatePasscodeUseCase = UpdatePasscodeUseCase(repository: UserDefaultsSettingsRepository())

        TabView(selection: $selectedTab) {
            HomeTabView(repo: repo)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            SalesHistoryView(viewModel: SalesHistoryViewModel(repository: repo))
                .tabItem {
                    Label("Sales", systemImage: "chart.bar")
                }
                .badge(salesBadge > 0 ? "" : nil)
                .tag(1)

            CustomerListView(viewModel: CustomerListViewModel(repository: repo))
                .tabItem {
                    Label("Customers", systemImage: "person.3")
                }
                .badge(customersBadge > 0 ? "" : nil)
                .tag(2)

            ProfileView(viewModel: ProfileViewModel(updatePasscodeUseCase: updatePasscodeUseCase, repository: repo))
                .tabItem {
                    Label("Profile", systemImage: "gearshape")
                }
                .tag(3)
        }
        .onChange(of: repo.sales.count) { newCount in
            if selectedTab != 1 {
                salesBadge = newCount
            }
        }
        .onChange(of: repo.customers.count) { newCount in
            if selectedTab != 2 {
                customersBadge = newCount
            }
        }
        .onChange(of: selectedTab) { tab in
            if tab == 1 { salesBadge = 0 }
            if tab == 2 { customersBadge = 0 }
        }
    }
}




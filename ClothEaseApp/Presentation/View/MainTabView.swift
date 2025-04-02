//
//  MainTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct MainTabView: View {
    @StateObject private var repo = LocalSalesRepository()

    var body: some View {
        let addSaleUseCase = AddSaleUseCase(repository: repo)
        let getSalesUseCase = GetSalesUseCase(repository: repo)
        let getCustomersUseCase = GetCustomersUseCase(repository: repo)
        let updatePasscodeUseCase = UpdatePasscodeUseCase(repository: UserDefaultsSettingsRepository())

        TabView {
            HomeTabView(repo: repo)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            SalesHistoryView(viewModel: SalesHistoryViewModel(repository: repo))
                .tabItem {
                    Label("Sales", systemImage: "chart.bar")
                }
                .badge(repo.sales.count)

            CustomerListView(viewModel: CustomerListViewModel(repository: repo))
                .tabItem {
                    Label("Customers", systemImage: "person.3")
                }
                .badge(repo.customers.count)

            ProfileView(viewModel: ProfileViewModel(updatePasscodeUseCase: updatePasscodeUseCase))
                .tabItem {
                    Label("Profile", systemImage: "gearshape")
                }
        }
    }
}



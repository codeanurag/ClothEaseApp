//
//  HomeTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct HomeTabView: View {
    let repo: LocalSalesRepository
    @State private var isShowingNewSale = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("No sales yet.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            .navigationTitle("Home")

            // Floating Button Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingButton(action: {
                        isShowingNewSale = true
                    }, icon: "plus")
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
            .sheet(isPresented: $isShowingNewSale) {
                SalesEntryView(
                    viewModel: SalesEntryViewModel(
                        addSaleUseCase: AddSaleUseCase(repository: repo)
                    )
                )
            }
        }
    }
}



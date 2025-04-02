//
//  HomeTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Charts
import SwiftUI
struct HomeTabView: View {
    let repo: LocalSalesRepository
    @State private var isShowingNewSale = false
    @StateObject private var viewModel: HomeTabViewModel

    init(repo: LocalSalesRepository) {
        self.repo = repo
        _viewModel = StateObject(wrappedValue: HomeTabViewModel(repository: repo))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if viewModel.dailyData.isEmpty {
                        Text("No sales yet.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Text("Profit Overview")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)

                        Chart {
                            ForEach(viewModel.dailyData) { day in
                                BarMark(
                                    x: .value("Date", day.date, unit: .day),
                                    y: .value("Profit", day.profit)
                                )
                                .foregroundStyle(day.profit >= 0 ? .green : .red)
                            }
                        }
                        .frame(height: 200)
                        .padding(.horizontal)

                        Divider()
                            .padding(.horizontal)

                        if let today = viewModel.todaySummary {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("🗓 Today")
                                    .font(.headline)

                                Text("🧾 Items Sold: \(today.itemsSold)")
                                Text("💰 Revenue: ₹\(Int(today.revenue))")
                                Text("💸 Expenses: ₹\(Int(today.expense))")
                                Text("📊 Profit: ₹\(Int(today.profit))")
                                    .foregroundColor(today.profit >= 0 ? .green : .red)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Home")
        }
        .sheet(isPresented: $isShowingNewSale) {
            SalesEntryView(
                viewModel: SalesEntryViewModel(
                    addSaleUseCase: AddSaleUseCase(repository: repo)
                )
            )
        }
        .overlay(
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
        )
    }
}



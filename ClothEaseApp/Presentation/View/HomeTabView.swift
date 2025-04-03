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

    @State private var selectedDate: Date? = nil
    @State private var showingDetail = false
    @State private var detailType: DetailType = .profit

    init(repo: LocalSalesRepository) {
        self.repo = repo
        _viewModel = StateObject(wrappedValue: HomeTabViewModel(repository: repo))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Grouping Toggle
                    Section {
                        Picker("View Mode", selection: $viewModel.groupingMode) {
                            ForEach(GroupingMode.allCases) { mode in
                                Text(mode.rawValue).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                    }

                    // MARK: - Profit Chart Section
                    if !viewModel.dailyData.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("📈 Profit Overview")
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

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.dailyData.sorted { $0.date > $1.date }) { day in
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(viewModel.shortDate(day.date))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)

                                            Text("🧾 \(day.itemsSold) sold")
                                            Text("💰 ₹\(Int(day.revenue))")
                                            Text("📊 ₹\(Int(day.profit))")
                                                .foregroundColor(day.profit >= 0 ? .green : .red)
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedDate = day.date
                                            detailType = .profit
                                            showingDetail = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }

                    Divider()

                    // MARK: - Expense Chart Section
                    if !viewModel.expenseData.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("💸 Expense Overview")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)

                            Chart {
                                ForEach(viewModel.expenseData) { item in
                                    BarMark(
                                        x: .value("Date", item.date, unit: .day),
                                        y: .value("Amount", item.total)
                                    )
                                    .foregroundStyle(.blue)
                                }
                            }
                            .frame(height: 200)
                            .padding(.horizontal)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(viewModel.expenseData.sorted { $0.date > $1.date }) { item in
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(viewModel.shortDate(item.date))
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)

                                            Text("🧾 \(item.entries) entry\(item.entries > 1 ? "ies" : "y")")
                                            Text("💸 ₹\(Int(item.total))")
                                        }
                                        .padding()
                                        .background(Color(.systemGray6))
                                        .cornerRadius(12)
                                        .onTapGesture {
                                            selectedDate = item.date
                                            detailType = .expense
                                            showingDetail = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Home")
            .sheet(isPresented: $showingDetail) {
                if let selected = selectedDate {
                    ExpenseProfitDetailView(
                        date: selected,
                        repo: repo,
                        type: detailType
                    )
                }
            }
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

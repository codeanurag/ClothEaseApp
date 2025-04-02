//
//  SalesHistoryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SalesHistoryView: View {
    @StateObject var viewModel: SalesHistoryViewModel
    @State private var isShowingNewSale = false
    @State private var selectedSale: Sale? = nil

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredSales, id: \.id) { sale in
                            VStack(alignment: .leading, spacing: 8) {
                                // Header
                                HStack {
                                    Text(sale.customer.name)
                                        .font(.headline)

                                    Spacer()

                                    Button {
                                        selectedSale = sale
                                    } label: {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }

                                // Product line
                                Text("📦 \(sale.products.map { $0.name }.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                // Show warning if any product is missing cost price
                                if sale.products.contains(where: { $0.costPrice == nil }) {
                                    Text("⚠ Missing cost price in one or more products")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }

                                // Date
                                Text("🕒 \(formattedDate(sale.timestamp))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteSale(sale)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .searchable(text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { _ in
                    viewModel.filterSales()
                }
                .onAppear {
                    viewModel.filterSales()
                }
                .navigationTitle("Sales History")
                .navigationDestination(item: $selectedSale) { sale in
                    SalesEntryView(
                        viewModel: SalesEntryViewModel(
                            addSaleUseCase: AddSaleUseCase(repository: viewModel.repository),
                            editing: sale
                        )
                    )
                }

                // Floating Button
                if selectedSale == nil && !isShowingNewSale {
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
                }
            }
        }
        .sheet(isPresented: $isShowingNewSale) {
            SalesEntryView(
                viewModel: SalesEntryViewModel(
                    addSaleUseCase: AddSaleUseCase(repository: viewModel.repository)
                )
            )
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

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
    @State private var saleToEdit: Sale? = nil

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Filters Section
                Section {
                    DisclosureGroup("Filters") {
                        VStack(spacing: 12) {
                            HStack {
                                DatePicker("From", selection: Binding(
                                    get: { viewModel.dateFrom ?? Date() },
                                    set: { viewModel.dateFrom = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()

                                DatePicker("To", selection: Binding(
                                    get: { viewModel.dateTo ?? Date() },
                                    set: { viewModel.dateTo = $0 }
                                ), displayedComponents: .date)
                                .labelsHidden()
                            }

                            TextField("Customer name/contact", text: $viewModel.customerFilter)
                                .textFieldStyle(.roundedBorder)

                            TextField("Product name", text: $viewModel.productFilter)
                                .textFieldStyle(.roundedBorder)

                            Button("Clear Filters") {
                                viewModel.dateFrom = nil
                                viewModel.dateTo = nil
                                viewModel.productFilter = ""
                                viewModel.customerFilter = ""
                                viewModel.searchText = ""
                                viewModel.filterSales()
                            }
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                        }
                        .padding(.vertical, 8)
                    }
                }

                // MARK: - Sales List
                if viewModel.filteredSales.isEmpty {
                    Text("No sales found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.filteredSales, id: \.id) { sale in
                        VStack(alignment: .leading, spacing: 10) {
                            // MARK: - Header
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(sale.customer.name)
                                        .font(.headline)

                                    Text(sale.customer.contact)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)

                                    Text(formattedDate(sale.timestamp))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                HStack(spacing: 12) {
                                    Button(action: {
                                        saleToEdit = sale
                                    }) {
                                        Image(systemName: "pencil")
                                            .foregroundColor(.blue)
                                            .padding(8)
                                            .background(Color(.systemGray5))
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                    Button(action: {
                                        viewModel.deleteSale(sale)
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color(.systemGray5))
                                            .clipShape(Circle())
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }

                            // MARK: - Product List
                            ForEach(sale.products, id: \.id) { product in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(product.name)
                                            .fontWeight(.medium)
                                        Text("Size: \(product.size)")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("₹\(Int(product.price))")
                                            .fontWeight(.medium)

                                        if let cost = product.costPrice {
                                            Text("(Cost: ₹\(Int(cost)))")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                            }

                            // MARK: - Missing Cost Alert
                            if sale.products.contains(where: { $0.costPrice == nil }) {
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .foregroundColor(.yellow)
                                    Text("Cost price missing for one or more items.\nProfit may be inaccurate.")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                }
                                .padding(.vertical, 4)
                            }

                            Divider()

                            // MARK: - Summary Row
                            let revenue = sale.products.reduce(0) { $0 + $1.price }
                            let cost = sale.products.reduce(0) { $0 + ($1.costPrice ?? 0) }
                            let profit = revenue - cost

                            VStack(alignment: .leading, spacing: 6) {
                                Text("Revenue: ₹\(Int(revenue))")
                                Text("Cost: ₹\(Int(cost))")
                                Text("Profit: ₹\(Int(profit))")
                                    .foregroundColor(profit >= 0 ? .green : .red)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .onChange(of: viewModel.searchText) { _ in viewModel.filterSales() }
            .onChange(of: viewModel.dateFrom) { _ in viewModel.filterSales() }
            .onChange(of: viewModel.dateTo) { _ in viewModel.filterSales() }
            .onChange(of: viewModel.customerFilter) { _ in viewModel.filterSales() }
            .onChange(of: viewModel.productFilter) { _ in viewModel.filterSales() }
            .navigationTitle("Sales History")
        }

        // MARK: - FAB + Add Sheet
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
        .sheet(isPresented: $isShowingNewSale) {
            SalesEntryView(
                viewModel: SalesEntryViewModel(
                    addSaleUseCase: AddSaleUseCase(repository: viewModel.repository)
                )
            )
        }
        .sheet(item: $saleToEdit) { sale in
            SalesEntryView(
                viewModel: SalesEntryViewModel(
                    addSaleUseCase: AddSaleUseCase(repository: viewModel.repository),
                    editing: sale
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


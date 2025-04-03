//
//  SalesHistoryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SalesHistoryView: View {
    @StateObject var viewModel: SalesHistoryViewModel

    var body: some View {
        NavigationStack {
            List {
                if viewModel.filteredSales.isEmpty {
                    Text("No sales found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(viewModel.filteredSales, id: \.id) { sale in
                        VStack(alignment: .leading, spacing: 10) {
                            // MARK: - Header
                            HStack {
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

                                Button {
                                    viewModel.deleteSale(sale)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }

                            Divider()

                            // MARK: - Product List
                            ForEach(sale.products, id: \.id) { product in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                        .fontWeight(.medium)

                                    HStack {
                                        Text("Size: \(product.size)")
                                        Spacer()
                                        Text("₹\(Int(product.price))")
                                        if let cost = product.costPrice {
                                            Text("(Cost: ₹\(Int(cost)))")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .font(.caption)
                                }
                                .padding(.vertical, 2)
                            }

                            Divider()

                            // MARK: - Summary
                            let revenue = sale.products.reduce(0) { $0 + $1.price }
                            let cost = sale.products.reduce(0) { $0 + ($1.costPrice ?? 0) }
                            let profit = revenue - cost

                            HStack {
                                Text("💰 Revenue: ₹\(Int(revenue))")
                                Spacer()
                                Text("💸 Cost: ₹\(Int(cost))")
                                Spacer()
                                Text("📊 Profit: ₹\(Int(profit))")
                                    .foregroundColor(profit >= 0 ? .green : .red)
                            }
                            .font(.subheadline)
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Sales History")
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


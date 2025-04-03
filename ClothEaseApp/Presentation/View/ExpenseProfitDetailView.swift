//
//  ExpenseProfitDetailView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 03/04/25.
//


import SwiftUI

struct ExpenseProfitDetailView: View {
    let date: Date
    let repo: LocalSalesRepository
    let type: DetailType

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(formattedDate(date))
                        .font(.title2)
                        .fontWeight(.semibold)

                    Divider()

                    if type == .profit {
                        let sales = repo.getAllSales().filter {
                            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
                        }

                        if sales.isEmpty {
                            Text("No sales recorded.")
                                .foregroundColor(.secondary)
                        } else {
                            let products = sales.flatMap { $0.products }
                            let revenue = products.reduce(0) { $0 + $1.price }
                            let cost = products.reduce(0) { $0 + ($1.costPrice ?? 0) }
                            let profit = revenue - cost

                            Group {
                                Text("🧾 Products Sold: \(products.count)")
                                Text("💰 Revenue: ₹\(Int(revenue))")
                                Text("💸 Cost: ₹\(Int(cost))")
                                Text("📊 Profit: ₹\(Int(profit))")
                                    .foregroundColor(profit >= 0 ? .green : .red)
                            }

                            Divider()

                            ForEach(products, id: \.id) { product in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                        .fontWeight(.medium)
                                    HStack {
                                        Text("Price: ₹\(Int(product.price))")
                                        Spacer()
                                        if let cost = product.costPrice {
                                            Text("Cost: ₹\(Int(cost))")
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }

                    } else {
                        let entries = repo.getExpenses(for: date)
                        if entries.isEmpty {
                            Text("No expenses recorded.")
                                .foregroundColor(.secondary)
                        } else {
                            let total = entries.reduce(0) { $0 + $1.amount }

                            Text("💸 Total: ₹\(Int(total))")

                            Divider()

                            ForEach(entries) { entry in
                                HStack {
                                    Text(entry.note)
                                    Spacer()
                                    Text("₹\(Int(entry.amount))")
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle(type == .profit ? "Profit Detail" : "Expenses Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

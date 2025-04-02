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
                ForEach(viewModel.filteredSales) { sale in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Customer: \(sale.customer.name)").font(.headline)
                        Text("Products: \(sale.products.map { $0.name }.joined(separator: ", "))")
                            .font(.subheadline)
                        Text("Date: \(formattedDate(sale.timestamp))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
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

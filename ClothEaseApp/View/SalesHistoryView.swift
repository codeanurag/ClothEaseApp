//
//  SalesHistoryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct SalesHistoryView: View {
    @StateObject private var viewModel = SalesViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredSales) { sale in
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Customer: \(sale.customer.name)")
                            .font(.headline)
                        Text("Products: \(sale.products.map { $0.name }.joined(separator: ", "))")
                            .font(.subheadline)
                        Text("Date: \(formattedDate(sale.timestamp))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Sales History")
        }
    }

    var filteredSales: [Sale] {
        viewModel.searchSales(by: searchText)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


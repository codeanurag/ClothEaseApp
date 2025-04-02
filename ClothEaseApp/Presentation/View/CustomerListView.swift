//
//  CustomerListView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct CustomerListView: View {
    @StateObject var viewModel: CustomerListViewModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.filteredCustomers) { customer in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(customer.name).font(.headline)
                        Text("📞 \(customer.contact)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("🛍️ Purchases: \(viewModel.saleCount(for: customer))")
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Customers")
        }
    }
}

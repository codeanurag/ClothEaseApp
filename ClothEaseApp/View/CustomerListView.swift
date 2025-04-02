//
//  CustomerListView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct CustomerListView: View {
    @EnvironmentObject var viewModel: SalesViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCustomers) { customer in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(customer.name)
                            .font(.headline)
                        Text("📞 \(customer.contact)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("🛍️ Purchases: \(viewModel.salesForCustomer(customer).count)")
                            .font(.caption)
                    }
                    .padding(.vertical, 4)
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Customers")
        }
    }

    var filteredCustomers: [Customer] {
        if searchText.isEmpty { return viewModel.customers }
        return viewModel.customers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.contact.localizedCaseInsensitiveContains(searchText)
        }
    }
}


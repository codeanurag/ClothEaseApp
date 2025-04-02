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
                    NavigationLink(
                        destination: EditCustomerView(
                            name: customer.name,
                            contact: customer.contact,
                            customerId: customer.id,
                            repo: viewModel.repository
                        )
                    ) {
                        CustomerCardView(
                            contact: .constant(customer.contact),
                            name: .constant(customer.name),
                            isEditable: false
                        )
                    }

                }
            }
            .searchable(text: $viewModel.searchText)
            .navigationTitle("Customers")
        }
    }
}

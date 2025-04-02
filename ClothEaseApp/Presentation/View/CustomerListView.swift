//
//  CustomerListView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct CustomerListView: View {
    @StateObject var viewModel: CustomerListViewModel
    @State private var isShowingNewCustomer = false

    var body: some View {
        ZStack {
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

            // Floating Button Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingButton(action: {
                        isShowingNewCustomer = true
                    }, icon: "plus")
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isShowingNewCustomer) {
            AddCustomerView(repo: viewModel.repository)
        }
    }
}


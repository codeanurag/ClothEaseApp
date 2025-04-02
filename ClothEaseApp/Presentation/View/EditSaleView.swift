//
//  EditSaleView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct EditSaleView: View {
    @Environment(\.dismiss) var dismiss
    let sale: Sale
    let repo: LocalSalesRepository

    @State private var customerName: String
    @State private var customerContact: String
    @State private var products: [Product]

    init(sale: Sale, repo: LocalSalesRepository) {
        self.sale = sale
        self.repo = repo
        _customerName = State(initialValue: sale.customer.name)
        _customerContact = State(initialValue: sale.customer.contact)
        _products = State(initialValue: sale.products)
    }

    var body: some View {
        Form {
            Section(header: Text("Customer")) {
                TextField("Name", text: $customerName)
                TextField("Contact", text: $customerContact)
                    .keyboardType(.numberPad)
            }

            Section(header: Text("Products")) {
                ForEach(products.indices, id: \.self) { index in
                    VStack(alignment: .leading) {
                        TextField("Product Name", text: $products[index].name)
                        TextField("Price", value: $products[index].price, format: .number)
                            .keyboardType(.decimalPad)
                        TextField("Size", text: $products[index].size)
                    }
                }
            }

            Button("Save Changes") {
                saveUpdatedSale()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
        }
        .navigationTitle("Edit Sale")
    }

    func saveUpdatedSale() {
        let updatedCustomer = Customer(id: sale.customer.id, name: customerName, contact: customerContact)
        let updatedSale = Sale(id: sale.id, customer: updatedCustomer, products: products, timestamp: sale.timestamp)

        if let index = repo.sales.firstIndex(where: { $0.id == sale.id }) {
            repo.sales[index] = updatedSale
            repo.saveAll() // you'll add this method
        }

        dismiss()
    }
}

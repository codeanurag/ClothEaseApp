//
//  SalesEntryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct SalesEntryView: View {
    @StateObject private var viewModel = SalesViewModel()
    @State private var customerName = ""
    @State private var customerContact = ""
    @State private var productName = ""
    @State private var productPrice = ""
    @State private var productSize = ""
    @State private var products: [Product] = []
    @State private var showAlert = false

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                TextField("Name", text: $customerName)
                TextField("Contact Number", text: $customerContact)
                    .keyboardType(.phonePad)
            }

            Section(header: Text("Product Details")) {
                TextField("Product Name", text: $productName)
                TextField("Price", text: $productPrice)
                    .keyboardType(.decimalPad)
                TextField("Size", text: $productSize)

                Button("Add Product") {
                    addProduct()
                }
            }

            if !products.isEmpty {
                Section(header: Text("Products Added")) {
                    ForEach(products) { product in
                        VStack(alignment: .leading) {
                            Text(product.name)
                            Text("₹\(product.price, specifier: "%.2f") • Size: \(product.size)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }

            Button("Save Sale") {
                saveSale()
            }
        }
        .navigationTitle("New Sale")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Sale saved!"), dismissButton: .default(Text("OK")))
        }
    }

    private func addProduct() {
        guard !productName.isEmpty,
              let price = Double(productPrice),
              !productSize.isEmpty else { return }

        let product = Product(id: UUID().uuidString, name: productName, price: price, size: productSize)
        products.append(product)

        productName = ""
        productPrice = ""
        productSize = ""
    }

    private func saveSale() {
        guard !customerName.isEmpty, !customerContact.isEmpty, !products.isEmpty else { return }

        let customer = Customer(id: UUID().uuidString, name: customerName, contact: customerContact)
        viewModel.addSale(customer: customer, products: products)

        customerName = ""
        customerContact = ""
        products = []
        showAlert = true
    }
}

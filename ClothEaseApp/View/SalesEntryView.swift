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
    @State private var selectedSize = "XL"
    @State private var products: [Product] = []
    @State private var showAlert = false

    let sizes = ["S", "M", "L", "XL", "XXL", "XXXL"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    // Customer Section
                    Section(header: Text("Customer Details")) {
                        TextField("Name", text: $customerName)

                        TextField("Contact Number", text: $customerContact)
                            .keyboardType(.numberPad)
                            .onChange(of: customerContact) { newValue in
                                // Remove non-digits and limit to 10
                                let filtered = newValue.filter { $0.isNumber }
                                customerContact = String(filtered.prefix(10))
                            }

                    }

                    // Product Section
                    Section(header: Text("Product Details")) {
                        TextField("Product Name", text: $productName)

                        TextField("Price", text: $productPrice)
                            .keyboardType(.decimalPad)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Size")
                                .font(.subheadline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(sizes, id: \.self) { size in
                                        Button(action: {
                                            selectedSize = size
                                        }) {
                                            Text(size)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(selectedSize == size ? Color.blue : Color.gray.opacity(0.2))
                                                .foregroundColor(selectedSize == size ? .white : .primary)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }

                        Button("Add Product") {
                            addProduct()
                        }
                        .padding(.top, 8)
                    }

                    // Products Added Section
                    if !products.isEmpty {
                        Section(header: Text("Products Added")) {
                            ForEach(products) { product in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(product.name)
                                    Text("₹\(product.price, specifier: "%.2f") • Size: \(product.size)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }

                // Save Sale Button (Fixed at bottom)
                Button(action: saveSale) {
                    Text("Save Sale")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.bottom, 16)
                .alert("Sale Saved", isPresented: $showAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            .navigationTitle("New Sale")
        }
    }

    private func addProduct() {
        guard !productName.isEmpty,
              let price = Double(productPrice) else { return }

        let product = Product(id: UUID().uuidString, name: productName, price: price, size: selectedSize)
        products.append(product)

        productName = ""
        productPrice = ""
        selectedSize = "XL"
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


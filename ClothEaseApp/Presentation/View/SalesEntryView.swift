//
//  SalesEntryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct SalesEntryView: View {
    @StateObject var viewModel: SalesEntryViewModel

    let sizes = ["S", "M", "L", "XL", "XXL", "XXXL"]

    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    Section(header: Text("Customer Details")) {
                        TextField("Name", text: $viewModel.customerName)
                        TextField("Contact Number", text: $viewModel.customerContact)
                            .keyboardType(.numberPad)
                            .onChange(of: viewModel.customerContact) { newValue in
                                let filtered = newValue.filter { $0.isNumber }
                                viewModel.customerContact = String(filtered.prefix(10))
                            }
                    }

                    Section(header: Text("Product Details")) {
                        TextField("Product Name", text: $viewModel.productName)
                        TextField("Price", text: $viewModel.productPrice)
                            .keyboardType(.decimalPad)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Size")
                                .font(.subheadline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(sizes, id: \.self) { size in
                                        Button(action: {
                                            viewModel.selectedSize = size
                                        }) {
                                            Text(size)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(viewModel.selectedSize == size ? Color.blue : Color.gray.opacity(0.2))
                                                .foregroundColor(viewModel.selectedSize == size ? .white : .primary)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                        }


                        Button("Add Product") {
                            viewModel.addProduct()
                        }
                    }

                    if !viewModel.products.isEmpty {
                        Section(header: Text("Products Added")) {
                            ForEach(viewModel.products) { product in
                                VStack(alignment: .leading) {
                                    Text(product.name)
                                    Text("₹\(product.price, specifier: "%.2f") • Size: \(product.size)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }

                Button("Save Sale") {
                    viewModel.saveSale()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .alert("Sale Saved!", isPresented: $viewModel.saleSaved) {
                    Button("OK", role: .cancel) { }
                }
            }
            .navigationTitle("New Sale")
        }
    }
}



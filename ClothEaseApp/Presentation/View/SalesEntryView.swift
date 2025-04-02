//
//  SalesEntryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SalesEntryView: View {
    @StateObject var viewModel: SalesEntryViewModel
    @Environment(\.dismiss) var dismiss

    let sizes = ["S", "M", "L", "XL", "XXL", "XXXL"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    // MARK: Customer Section
                    Section {
                        CustomerCardView(
                            contact: $viewModel.customerContact,
                            name: $viewModel.customerName,
                            isEditable: true,
                            title: "Customer Details"
                        )
                    }

                    // MARK: Product Cards (Editable)
                    if !viewModel.products.isEmpty {
                        Section(header: Text("Products")) {
                            ForEach($viewModel.products, id: \.id) { $product in
                                ProductCardView(
                                    product: $product,
                                    sizes: sizes,
                                    isEditable: true
                                )
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // MARK: Add New Product Section
                    Section(header: Text("Add Product")) {
                        TextField("Product Name", text: $viewModel.productName)

                        TextField("Price", text: $viewModel.productPrice)
                            .keyboardType(.decimalPad)

                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Size").font(.subheadline)

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
                        .padding(.top, 6)
                    }
                }

                // MARK: Save/Update Button
                Button(viewModel.isEditing ? "Update Sale" : "Save Sale") {
                    viewModel.saveSale()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        dismiss()
                    }
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .navigationTitle(viewModel.isEditing ? "Edit Sale" : "New Sale")
            .toast(message: viewModel.isEditing ? "Sale Updated" : "Sale Saved",
                   isShowing: $viewModel.saleSaved)
        }
    }
}

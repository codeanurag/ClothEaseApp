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
    let productTypes = ["Kurti", "Sharara", "Single Kurti", "Cord Set", "Thali Cover", "Other"]

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
                            ForEach(Array(viewModel.products.enumerated()), id: \.element.id) { index, product in
                                ProductCardView(
                                    onDelete: {
                                        viewModel.products.remove(at: index)
                                    }, product: $viewModel.products[index],
                                    sizes: sizes,
                                    isEditable: true
                                )
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // MARK: Add New Product Section
                    Section(header: Text("Add Product")) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Select Product Type").font(.subheadline)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(productTypes, id: \.self) { type in
                                        Button(action: {
                                            viewModel.selectedProductType = type
                                        }) {
                                            Text(type)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                                .background(viewModel.selectedProductType == type ? Color.blue : Color.gray.opacity(0.2))
                                                .foregroundColor(viewModel.selectedProductType == type ? .white : .primary)
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }

                            if viewModel.selectedProductType == "Other" || viewModel.selectedProductType == nil {
                                TextField("Enter full product name", text: $viewModel.productName)
                            } else {
                                TextField("Extra details (optional)", text: $viewModel.productDescription)
                                    .onChange(of: viewModel.productDescription) { _ in
                                        viewModel.updateComposedProductName()
                                    }
                            }
                        }

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
                        .onChange(of: viewModel.selectedProductType) { _ in
                            viewModel.updateComposedProductName()
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
                .padding(.bottom, 16)
                .disabled(!viewModel.canSave)
                .opacity(viewModel.canSave ? 1.0 : 0.5)
            }
            .navigationTitle(viewModel.isEditing ? "Edit Sale" : "New Sale")
            .toast(message: viewModel.isEditing ? "Sale Updated" : "Sale Saved",
                   isShowing: $viewModel.saleSaved)
        }
    }
}

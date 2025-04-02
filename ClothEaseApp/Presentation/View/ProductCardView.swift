//
//  ProductCardView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct ProductCardView: View {
    var onDelete: (() -> Void)? = nil
    @Binding var product: Product
    let sizes: [String]
    let isEditable: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if isEditable {
                HStack {
                    TextField("Product Name", text: $product.name)
                    
                    Spacer()
                    
                    if let onDelete = onDelete {
                        Button(action: onDelete) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
                TextField("Price", value: $product.price, format: .number)
                    .keyboardType(.decimalPad)

                Text("Size")
                    .font(.subheadline)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(sizes, id: \.self) { size in
                            Button(action: {
                                product.size = size
                            }) {
                                Text(size)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(product.size == size ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(product.size == size ? .white : .primary)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            } else {
                Text(product.name)
                    .font(.headline)

                Text("₹\(product.price, specifier: "%.2f")")
                    .font(.subheadline)

                Text("Size: \(product.size)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

//
//  CustomerCardView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct CustomerCardView: View {
    @Binding var contact: String
    @Binding var name: String

    var isEditable: Bool = true
    var title: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = title {
                Text(title)
                    .font(.headline)
            }

            if isEditable {
                TextField("Contact Number", text: $contact)
                    .keyboardType(.numberPad)
                    .onChange(of: contact) { newValue in
                        let filtered = newValue.filter { $0.isNumber }
                        contact = String(filtered.prefix(10))
                    }

                TextField("Customer Name", text: $name)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text("📞 \(contact)")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text(name)
                        .font(.headline)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}


//
//  EditCustomerView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct EditCustomerView: View {
    @Environment(\.dismiss) var dismiss

    @State var name: String
    @State var contact: String

    let customerId: String
    let repo: LocalSalesRepository

    var body: some View {
        Form {
            Section {
                CustomerCardView(
                    contact: $contact,
                    name: $name,
                    isEditable: true,
                    title: "Edit Customer"
                )
            }

            Section {
                Button("Update Customer") {
                    updateCustomer()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
        }
        .navigationTitle("Edit Customer")
    }

    private func updateCustomer() {
        let updated = Customer(id: customerId, name: name, contact: contact)
        repo.updateCustomerEverywhere(updatedCustomer: updated)
        dismiss()
    }
}

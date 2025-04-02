//
//  AddCustomerView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct AddCustomerView: View {
    @Environment(\.dismiss) var dismiss
    @State private var contact: String = ""
    @State private var name: String = ""
    @State private var showToast = false

    let repo: LocalSalesRepository

    var body: some View {
        Form {
            Section {
                CustomerCardView(
                    contact: $contact,
                    name: $name,
                    isEditable: true,
                    title: "Add New Customer"
                )
            }

            Section {
                Button("Save Customer") {
                    saveCustomer()
                }
                .disabled(!canSave)
                .opacity(canSave ? 1 : 0.5)
            }
        }
        .navigationTitle("Add Customer")
        .toast(message: "Customer Saved!", isShowing: $showToast)
    }

    var canSave: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        contact.count == 10 &&
        !repo.customers.contains(where: { $0.contact == contact })
    }

    func saveCustomer() {
        let newCustomer = Customer(
            id: UUID().uuidString,
            name: name,
            contact: contact
        )

        repo.customers.append(newCustomer)
        repo.saveCustomers()

        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            dismiss()
        }
    }
}

//
//  SalesViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//

import SwiftUI
class SalesViewModel: ObservableObject {
    @Published var sales: [Sale] = []
    @Published var customers: [Customer] = []

    func addSale(customer: Customer, products: [Product]) {
        let sale = Sale(id: UUID().uuidString, customerID: customer.id, products: products, timestamp: Date())
        sales.append(sale)
        if !customers.contains(where: { $0.id == customer.id }) {
            customers.append(customer)
        }
    }
}

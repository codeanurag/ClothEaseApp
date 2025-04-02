//
//  SalesViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation
import SwiftUI

class SalesViewModel: ObservableObject {
    @Published var sales: [Sale] = []
    @Published var customers: [Customer] = []

    func addSale(customer: Customer, products: [Product]) {
        let sale = Sale(id: UUID().uuidString,
                        customer: customer,
                        products: products,
                        timestamp: Date())

        sales.append(sale)

        if !customers.contains(where: { $0.id == customer.id }) {
            customers.append(customer)
        }
    }

    func salesForCustomer(_ customer: Customer) -> [Sale] {
        sales.filter { $0.customer.id == customer.id }
    }

    func searchSales(by text: String) -> [Sale] {
        if text.isEmpty { return sales }
        return sales.filter {
            $0.customer.name.localizedCaseInsensitiveContains(text) ||
            $0.products.contains(where: { $0.name.localizedCaseInsensitiveContains(text) })
        }
    }
}

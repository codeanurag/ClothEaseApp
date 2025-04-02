//
//  LocalSalesRepository.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation
import Combine
class LocalSalesRepository: SalesRepository, ObservableObject {
    private let salesKey = "saved_sales"
    private let customersKey = "saved_customers"

    @Published private(set) var sales: [Sale] = []
    @Published private(set) var customers: [Customer] = []
    init() {
        loadSales()
        loadCustomers()
    }

    func addSale(_ sale: Sale) {
        sales.append(sale)
        if !customers.contains(where: { $0.id == sale.customer.id }) {
            customers.append(sale.customer)
        }
        saveSales()
        saveCustomers()
    }

    func getAllSales() -> [Sale] {
        return sales
    }

    func getAllCustomers() -> [Customer] {
        return customers
    }

    private func saveSales() {
        if let data = try? JSONEncoder().encode(sales) {
            UserDefaults.standard.set(data, forKey: salesKey)
        }
    }

    private func saveCustomers() {
        if let data = try? JSONEncoder().encode(customers) {
            UserDefaults.standard.set(data, forKey: customersKey)
        }
    }

    private func loadSales() {
        guard let data = UserDefaults.standard.data(forKey: salesKey),
              let decoded = try? JSONDecoder().decode([Sale].self, from: data) else { return }
        sales = decoded
    }

    private func loadCustomers() {
        guard let data = UserDefaults.standard.data(forKey: customersKey),
              let decoded = try? JSONDecoder().decode([Customer].self, from: data) else { return }
        customers = decoded
    }
}

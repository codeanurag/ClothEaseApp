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

    @Published var sales: [Sale] = []
    @Published var customers: [Customer] = []
    init() {
        loadSales()
        loadCustomers()
    }

    func addSale(_ sale: Sale) {
        // 1. Add or replace the sale
        if let index = sales.firstIndex(where: { $0.id == sale.id }) {
            sales[index] = sale
        } else {
            sales.append(sale)
        }
        
        // 2. Update or add customer in customer list
        if let customerIndex = customers.firstIndex(where: { $0.id == sale.customer.id }) {
            customers[customerIndex] = sale.customer
        } else {
            customers.append(sale.customer)
        }
        
        // 3. ✅ Update the customer info in all other sales with same customer ID
        for i in sales.indices {
            if sales[i].customer.id == sale.customer.id {
                sales[i] = Sale(
                    id: sales[i].id,
                    customer: sale.customer,
                    products: sales[i].products,
                    timestamp: sales[i].timestamp
                )
            }
        }
        
        saveSales()
        saveCustomers()
    }

    func updateCustomerEverywhere(updatedCustomer: Customer) {
        // 1. Update in customer list
        if let index = customers.firstIndex(where: { $0.id == updatedCustomer.id }) {
            customers[index] = updatedCustomer
        }
        
        // 2. Update in sales list
        for i in sales.indices {
            if sales[i].customer.id == updatedCustomer.id {
                let updatedSale = Sale(
                    id: sales[i].id,
                    customer: updatedCustomer,
                    products: sales[i].products,
                    timestamp: sales[i].timestamp
                )
                sales[i] = updatedSale
            }
        }
        
        saveAll()
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

    func saveCustomers() {
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
    func saveAll() {
        saveSales()
        saveCustomers()
    }

    func deleteSale(byId id: String) {
        sales.removeAll { $0.id == id }
        saveSales()
    }
    func deleteCustomer(byId id: String) {
        customers.removeAll { $0.id == id }
        sales.removeAll { $0.customer.id == id } // Optional: remove their sales too
        saveCustomers()
        saveSales()
    }

}

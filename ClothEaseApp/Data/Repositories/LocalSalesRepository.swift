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
    private let expensesKey = "saved_expenses" // ✅ NEW

    @Published var dailyExpenses: [DailyExpense] = []
    @Published var sales: [Sale] = []
    @Published var customers: [Customer] = []

    init() {
        loadSales()
        loadCustomers()
        loadExpenses() // ✅ Load saved expenses on startup
    }

    func addSale(_ sale: Sale) {
        if let index = sales.firstIndex(where: { $0.id == sale.id }) {
            sales[index] = sale
        } else {
            sales.append(sale)
        }

        if let customerIndex = customers.firstIndex(where: { $0.id == sale.customer.id }) {
            customers[customerIndex] = sale.customer
        } else {
            customers.append(sale.customer)
        }

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
        if let index = customers.firstIndex(where: { $0.id == updatedCustomer.id }) {
            customers[index] = updatedCustomer
        }

        for i in sales.indices {
            if sales[i].customer.id == updatedCustomer.id {
                sales[i] = Sale(
                    id: sales[i].id,
                    customer: updatedCustomer,
                    products: sales[i].products,
                    timestamp: sales[i].timestamp
                )
            }
        }

        saveAll()
    }

    // ✅ New method to add expense with persistence
    func addExpense(for date: Date, amount: Double, note: String) {
        let entry = ExpenseEntry(amount: amount, note: note)

        if let index = dailyExpenses.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            dailyExpenses[index].entries.append(entry)
        } else {
            dailyExpenses.append(DailyExpense(date: date, entries: [entry]))
        }

        saveExpenses()
    }

    func expense(for date: Date) -> Double {
        dailyExpenses
            .first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?
            .entries
            .reduce(0) { $0 + $1.amount } ?? 0
    }

    func getExpenses(for date: Date) -> [ExpenseEntry] {
        dailyExpenses
            .first(where: { Calendar.current.isDate($0.date, inSameDayAs: date) })?
            .entries ?? []
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

    // ✅ NEW: Save expenses to UserDefaults
    private func saveExpenses() {
        if let data = try? JSONEncoder().encode(dailyExpenses) {
            UserDefaults.standard.set(data, forKey: expensesKey)
        }
    }

    // ✅ NEW: Load saved expenses
    private func loadExpenses() {
        guard let data = UserDefaults.standard.data(forKey: expensesKey),
              let decoded = try? JSONDecoder().decode([DailyExpense].self, from: data) else { return }
        dailyExpenses = decoded
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
        saveExpenses()
    }

    func deleteSale(byId id: String) {
        sales.removeAll { $0.id == id }
        saveSales()
    }

    func deleteCustomer(byId id: String) {
        customers.removeAll { $0.id == id }
        sales.removeAll { $0.customer.id == id }
        saveCustomers()
        saveSales()
    }
}


//
//  SalesHistoryViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//
import Foundation
import Combine

class SalesHistoryViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredSales: [Sale] = []

    // 🔍 Filters
    @Published var dateFrom: Date? = nil
    @Published var dateTo: Date? = nil
    @Published var productFilter: String = ""
    @Published var customerFilter: String = ""

    let repository: LocalSalesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: LocalSalesRepository) {
        self.repository = repository

        repository.$sales
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.filterSales()
            }
            .store(in: &cancellables)
    }

    func deleteSale(_ sale: Sale) {
        repository.deleteSale(byId: sale.id)
    }

    func saleCount(for customer: Customer) -> Int {
        repository.sales.filter { $0.customer.id == customer.id }.count
    }

    func filterSales() {
        filteredSales = repository.sales.filter { sale in
            // Search Text (freeform)
            let query = searchText.lowercased()
            let matchesSearch = query.isEmpty ||
                sale.customer.name.lowercased().contains(query) ||
                sale.products.contains(where: { $0.name.lowercased().contains(query) }) ||
                formattedDate(sale.timestamp).lowercased().contains(query)

            // Date filter
            let matchesDate = (dateFrom == nil || sale.timestamp >= dateFrom!) &&
                              (dateTo == nil || sale.timestamp <= dateTo!)

            // Customer filter
            let matchesCustomer = customerFilter.isEmpty ||
                sale.customer.name.localizedCaseInsensitiveContains(customerFilter) ||
                sale.customer.contact.contains(customerFilter)

            // Product filter
            let matchesProduct = productFilter.isEmpty ||
                sale.products.contains { $0.name.localizedCaseInsensitiveContains(productFilter) }

            return matchesSearch && matchesDate && matchesCustomer && matchesProduct
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}



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
        if searchText.isEmpty {
            filteredSales = repository.sales
        } else {
            let lowercasedQuery = searchText.lowercased()

            filteredSales = repository.sales.filter { sale in
                sale.customer.name.lowercased().contains(lowercasedQuery) ||
                sale.products.contains(where: { $0.name.lowercased().contains(lowercasedQuery) }) ||
                formattedDate(sale.timestamp).lowercased().contains(lowercasedQuery)
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


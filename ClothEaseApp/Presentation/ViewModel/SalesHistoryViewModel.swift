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
    @Published var allSales: [Sale] = []

    private var repository: LocalSalesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: LocalSalesRepository) {
        self.repository = repository
        bind()
    }

    private func bind() {
        repository.$sales
            .receive(on: RunLoop.main)
            .assign(to: &$allSales)
    }

    var filteredSales: [Sale] {
        if searchText.isEmpty { return allSales }
        return allSales.filter {
            $0.customer.name.localizedCaseInsensitiveContains(searchText) ||
            $0.products.contains { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

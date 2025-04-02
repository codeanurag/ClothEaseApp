//
//  CustomerListViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation
import Combine
class CustomerListViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var allCustomers: [Customer] = []

    private var repository: LocalSalesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: LocalSalesRepository) {
        self.repository = repository
        bind()
    }

    private func bind() {
        repository.$customers
            .receive(on: RunLoop.main)
            .assign(to: &$allCustomers)
    }

    func saleCount(for customer: Customer) -> Int {
        repository.sales.filter { $0.customer.id == customer.id }.count
    }

    var filteredCustomers: [Customer] {
        if searchText.isEmpty { return allCustomers }
        return allCustomers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.contact.localizedCaseInsensitiveContains(searchText)
        }
    }
}


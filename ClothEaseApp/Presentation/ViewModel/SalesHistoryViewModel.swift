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
            .assign(to: &$filteredSales)
    }
}


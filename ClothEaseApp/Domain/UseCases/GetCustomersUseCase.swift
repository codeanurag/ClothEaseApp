//
//  GetCustomersUseCase.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class GetCustomersUseCase {
    private let repository: SalesRepository

    init(repository: SalesRepository) {
        self.repository = repository
    }

    func execute() -> [Customer] {
        return repository.getAllCustomers()
    }
}

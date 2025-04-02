//
//  GetSalesUseCase.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class GetSalesUseCase {
    private let repository: SalesRepository

    init(repository: SalesRepository) {
        self.repository = repository
    }

    func execute() -> [Sale] {
        return repository.getAllSales()
    }
}

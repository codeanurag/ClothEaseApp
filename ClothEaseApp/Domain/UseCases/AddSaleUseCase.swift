//
//  AddSaleUseCase.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class AddSaleUseCase {
    private let repository: SalesRepository

    init(repository: SalesRepository) {
        self.repository = repository
    }

    func execute(customer: Customer, products: [Product]) {
        let sale = Sale(id: UUID().uuidString, customer: customer, products: products, timestamp: Date())
        repository.addSale(sale)
    }
    func execute(customer: Customer, products: [Product], overrideId: String? = nil) {
        let sale = Sale(
            id: overrideId ?? UUID().uuidString,
            customer: customer,
            products: products,
            timestamp: Date()
        )
        repository.addSale(sale)
    }

}

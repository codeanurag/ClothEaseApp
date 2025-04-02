//
//  SalesEntryViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class SalesEntryViewModel: ObservableObject {
    @Published var customerName = ""
    @Published var customerContact = ""
    @Published var productName = ""
    @Published var productPrice = ""
    @Published var selectedSize = "XL"
    @Published var products: [Product] = []
    @Published var saleSaved = false

    private let addSaleUseCase: AddSaleUseCase

    init(addSaleUseCase: AddSaleUseCase) {
        self.addSaleUseCase = addSaleUseCase
    }

    func addProduct() {
        guard !productName.isEmpty, let price = Double(productPrice) else { return }

        let product = Product(id: UUID().uuidString, name: productName, price: price, size: selectedSize)
        products.append(product)

        productName = ""
        productPrice = ""
        selectedSize = "XL"
    }

    func saveSale() {
        guard !customerName.isEmpty, !customerContact.isEmpty, !products.isEmpty else { return }

        let customer = Customer(id: UUID().uuidString, name: customerName, contact: customerContact)
        addSaleUseCase.execute(customer: customer, products: products)

        customerName = ""
        customerContact = ""
        products = []
        saleSaved = true
    }
}

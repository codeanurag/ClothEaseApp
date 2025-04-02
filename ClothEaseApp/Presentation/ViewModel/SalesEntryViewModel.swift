//
//  SalesEntryViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Foundation

class SalesEntryViewModel: ObservableObject {
    // MARK: - Form Fields
    @Published var customerName: String = ""
    @Published var customerContact: String = ""

    @Published var productName: String = ""
    @Published var productPrice: String = ""
    @Published var selectedSize: String = "XL"

    @Published var products: [Product] = []
    @Published var saleSaved: Bool = false

    // MARK: - Editing Existing Sale
    private var existingSale: Sale?
    private let addSaleUseCase: AddSaleUseCase

    var isEditing: Bool {
        existingSale != nil
    }

    // MARK: - Init
    init(addSaleUseCase: AddSaleUseCase, editing sale: Sale? = nil) {
        self.addSaleUseCase = addSaleUseCase
        self.existingSale = sale

        if let sale = sale {
            self.customerName = sale.customer.name
            self.customerContact = sale.customer.contact

            // Reuse existing product IDs or assign new ones safely
            self.products = sale.products.map { product in
                Product(
                    id: product.id.isEmpty ? UUID().uuidString : product.id,
                    name: product.name,
                    price: product.price,
                    size: product.size
                )
            }
        }
    }

    // MARK: - Add Product
    func addProduct() {
        let trimmedName = productName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty,
              let price = Double(productPrice),
              price > 0 else { return }

        let newProduct = Product(
            id: UUID().uuidString,
            name: trimmedName,
            price: price,
            size: selectedSize
        )

        products = products + [newProduct] // force SwiftUI update

        productName = ""
        productPrice = ""
        selectedSize = "XL"
    }

    // MARK: - Save or Update Sale
    func saveSale() {
        guard !customerName.isEmpty,
              !customerContact.isEmpty,
              !products.isEmpty else { return }

        let customer = Customer(
            id: existingSale?.customer.id ?? UUID().uuidString,
            name: customerName,
            contact: customerContact
        )

        let saleId = existingSale?.id ?? UUID().uuidString

        let newSale = Sale(
            id: saleId,
            customer: customer,
            products: products,
            timestamp: Date()
        )

        addSaleUseCase.execute(customer: customer, products: products, overrideId: saleId)

        saleSaved = true

        // Hide toast after 1.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.saleSaved = false
        }
    }
}


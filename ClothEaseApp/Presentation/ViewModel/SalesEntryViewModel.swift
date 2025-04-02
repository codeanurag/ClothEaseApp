//
//  SalesEntryViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Foundation

class SalesEntryViewModel: ObservableObject {
    // MARK: - Customer Fields
    @Published var customerContact: String = "" {
        didSet {
            autoPopulateCustomer()
        }
    }
    @Published var customerName: String = ""

    // MARK: - New Product Fields
    @Published var productName: String = ""
    @Published var productPrice: String = ""
    @Published var selectedSize: String = "XL"
    @Published var selectedProductType: String? = nil
    @Published var productDescription: String = ""

    // MARK: - Added Products
    @Published var products: [Product] = []

    // MARK: - Toast
    @Published var saleSaved: Bool = false

    private var existingSale: Sale?
    private let addSaleUseCase: AddSaleUseCase
    private let repo: LocalSalesRepository

    var canSave: Bool {
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        customerContact.count == 10 &&
        !products.isEmpty
    }

    var isEditing: Bool {
        existingSale != nil
    }

    // MARK: - Init
    init(addSaleUseCase: AddSaleUseCase, editing sale: Sale? = nil) {
        self.addSaleUseCase = addSaleUseCase
        self.repo = addSaleUseCase.repository as! LocalSalesRepository
        self.existingSale = sale

        if let sale = sale {
            self.customerName = sale.customer.name
            self.customerContact = sale.customer.contact

            self.products = sale.products.map {
                Product(
                    id: $0.id.isEmpty ? UUID().uuidString : $0.id,
                    name: $0.name,
                    price: $0.price,
                    size: $0.size
                )
            }
        }
    }

    // MARK: - Auto-fill Customer Name by Contact
    private func autoPopulateCustomer() {
        let trimmed = customerContact.filter { $0.isNumber }

        guard trimmed.count == 10 else {
            customerName = ""
            return
        }

        if let existing = repo.customers.first(where: { $0.contact == trimmed }) {
            customerName = existing.name
        }
    }

    // MARK: - Add New Product
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

        products = products + [newProduct]

        productName = ""
        productPrice = ""
        selectedSize = "XL"
        selectedProductType = nil
        productDescription = ""
    }

    func updateComposedProductName() {
        if let selected = selectedProductType, selected != "Other" {
            productName = "\(selected) \(productDescription)".trimmingCharacters(in: .whitespaces)
        }
    }

    // MARK: - Save or Update Sale
    func saveSale() {
        guard !customerContact.isEmpty,
              !customerName.isEmpty,
              !products.isEmpty else { return }

        let customerId = existingSale?.customer.id ??
            repo.customers.first(where: { $0.contact == customerContact })?.id ??
            UUID().uuidString

        let customer = Customer(
            id: customerId,
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.saleSaved = false
        }
    }
}


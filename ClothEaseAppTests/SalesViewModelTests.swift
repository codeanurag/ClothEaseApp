//
//  SalesViewModelTests.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import XCTest
@testable import ClothEaseApp

final class SalesViewModelTests: XCTestCase {

    func testAddSaleAddsToSalesAndCustomerList() {
        let viewModel = SalesViewModel()
        let customer = Customer(id: "c1", name: "John", contact: "9999999999")
        let product = Product(id: "p1", name: "T-Shirt", price: 499, size: "M")

        viewModel.addSale(customer: customer, products: [product])

        XCTAssertEqual(viewModel.sales.count, 1)
        XCTAssertEqual(viewModel.customers.count, 1)
    }

    func testSalesForCustomerReturnsCorrectSales() {
        let viewModel = SalesViewModel()
        let customer1 = Customer(id: "c1", name: "John", contact: "999")
        let customer2 = Customer(id: "c2", name: "Jane", contact: "888")
        let product = Product(id: "p1", name: "Shirt", price: 999, size: "L")

        viewModel.addSale(customer: customer1, products: [product])
        viewModel.addSale(customer: customer2, products: [product])

        let johnSales = viewModel.salesForCustomer(customer1)
        XCTAssertEqual(johnSales.count, 1)
        XCTAssertEqual(johnSales.first?.customer.name, "John")
    }

    func testSearchSalesFiltersByCustomerOrProduct() {
        let viewModel = SalesViewModel()
        let customer = Customer(id: "c1", name: "Anurag", contact: "123")
        let product = Product(id: "p1", name: "Hoodie", price: 1200, size: "XL")

        viewModel.addSale(customer: customer, products: [product])

        let result1 = viewModel.searchSales(by: "Anurag")
        XCTAssertFalse(result1.isEmpty)

        let result2 = viewModel.searchSales(by: "Hoodie")
        XCTAssertFalse(result2.isEmpty)

        let result3 = viewModel.searchSales(by: "Jeans")
        XCTAssertTrue(result3.isEmpty)
    }
}

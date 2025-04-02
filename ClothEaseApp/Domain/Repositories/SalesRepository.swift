//
//  SalesRepository.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


protocol SalesRepository {
    func addSale(_ sale: Sale)
    func getAllSales() -> [Sale]
    func getAllCustomers() -> [Customer]
}

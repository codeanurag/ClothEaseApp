//
//  Product.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//


struct Product: Identifiable, Codable, Equatable, Hashable {
    let id: String
    var name: String
    var price: Double
    var costPrice: Double? = nil
    var size: String
}

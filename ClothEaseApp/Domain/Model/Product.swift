//
//  Product.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//


struct Product: Identifiable, Codable, Equatable {
    let id: String
    var name: String
    var price: Double
    var size: String
}

//
//  Product.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//


struct Product: Identifiable, Codable {
    let id: String
    let name: String
    let price: Double
    let size: String
}
//
//  Customer.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//


struct Customer: Identifiable, Codable, Equatable, Hashable {
    let id: String
    let name: String
    let contact: String
}

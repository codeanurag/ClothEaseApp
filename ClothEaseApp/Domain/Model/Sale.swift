//
//  Sale.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

struct Sale: Identifiable, Codable, Hashable {
    let id: String
    let customer: Customer
    let products: [Product]
    let timestamp: Date
}

//
//  Sale.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

struct Sale: Identifiable, Codable {
    let id: String
    let customerID: String
    let products: [Product]
    let timestamp: Date
}

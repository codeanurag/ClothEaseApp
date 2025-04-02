//
//  Sale.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

struct Sale: Identifiable, Codable {
    let id: String
    let customer: Customer   // change from customerID to customer
    let products: [Product]
    let timestamp: Date
}

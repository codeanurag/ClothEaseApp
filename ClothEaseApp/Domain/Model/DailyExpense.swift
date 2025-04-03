//
//  DailyExpense.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Foundation
struct DailyExpense: Identifiable, Codable, Hashable {
    var id = UUID()
    var date: Date
    var entries: [ExpenseEntry]
}

struct ExpenseEntry: Identifiable, Codable, Hashable {
    var id = UUID()
    var amount: Double
    var note: String
}



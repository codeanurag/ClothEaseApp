//
//  DailyExpense.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Foundation
struct DailyExpense: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date
    var amount: Double
}


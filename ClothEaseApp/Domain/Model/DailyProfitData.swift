//
//  DailyProfitData.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation
import Combine

struct DailyProfitData: Identifiable {
    let id = UUID()
    let date: Date
    let revenue: Double
    let cost: Double
    let expense: Double
    var profit: Double {
        revenue - cost - expense
    }

    var itemsSold: Int
}

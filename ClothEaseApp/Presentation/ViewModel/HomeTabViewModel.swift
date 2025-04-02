//
//  HomeTabViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Combine
import Foundation
class HomeTabViewModel: ObservableObject {
    @Published var dailyData: [DailyProfitData] = []
    @Published var todaySummary: DailyProfitData?

    private let repository: LocalSalesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: LocalSalesRepository) {
        self.repository = repository
        observeData()
    }

    private func observeData() {
        repository.$sales
            .combineLatest(repository.$dailyExpenses)
            .receive(on: RunLoop.main)
            .sink { [weak self] _, _ in
                self?.generateData()
            }
            .store(in: &cancellables)
    }

    func generateData() {
        let calendar = Calendar.current
        let groupedSales = Dictionary(grouping: repository.sales) {
            calendar.startOfDay(for: $0.timestamp)
        }

        var result: [DailyProfitData] = []

        for (day, sales) in groupedSales {
            let items = sales.flatMap { $0.products }

            let revenue = items.reduce(0) { $0 + $1.price }
            let cost = items.reduce(0) { $0 + ($1.costPrice ?? 0) }
            let expense = repository.expense(for: day)

            let entry = DailyProfitData(
                date: day,
                revenue: revenue,
                cost: cost,
                expense: expense,
                itemsSold: items.count
            )

            result.append(entry)
        }

        dailyData = result.sorted { $0.date < $1.date }

        if let today = dailyData.first(where: { calendar.isDateInToday($0.date) }) {
            todaySummary = today
        }
    }
}


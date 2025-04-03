//
//  HomeTabViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Combine
import Foundation

struct ExpenseSummary: Identifiable {
    var id = UUID()
    var date: Date
    var total: Double
    var entries: Int
}

class HomeTabViewModel: ObservableObject {
    @Published var dailyData: [DailyProfitData] = []
    @Published var todaySummary: DailyProfitData?
    @Published var expenseData: [ExpenseSummary] = []

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

        // Group sales
        let groupedSales = Dictionary(grouping: repository.sales) {
            calendar.startOfDay(for: $0.timestamp)
        }

        var profitResult: [DailyProfitData] = []

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

            profitResult.append(entry)
        }

        dailyData = profitResult.sorted { $0.date < $1.date }

        if let today = dailyData.first(where: { calendar.isDateInToday($0.date) }) {
            todaySummary = today
        }

        // Generate expense data
        expenseData = repository.dailyExpenses.map { entry in
            ExpenseSummary(
                date: Calendar.current.startOfDay(for: entry.date),
                total: entry.entries.reduce(0) { $0 + $1.amount },
                entries: entry.entries.count
            )
        }
        .sorted { $0.date < $1.date }
    }

    func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter.string(from: date)
    }
}


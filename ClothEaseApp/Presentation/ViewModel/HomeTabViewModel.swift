//
//  HomeTabViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import Combine
import Foundation
enum DetailType {
    case profit
    case expense
}

struct ExpenseSummary: Identifiable {
    var id = UUID()
    var date: Date
    var total: Double
    var entries: Int
}

enum GroupingMode: String, CaseIterable, Identifiable {
    case day = "Day"
    case week = "Week"
    case month = "Month"

    var id: String { self.rawValue }
}

class HomeTabViewModel: ObservableObject {
    @Published var dailyData: [DailyProfitData] = []
    @Published var expenseData: [ExpenseSummary] = []
    @Published var todaySummary: DailyProfitData?
    @Published var groupingMode: GroupingMode = .day {
        didSet {
            generateData()
        }
    }

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

        func groupingKey(for date: Date) -> Date {
            switch groupingMode {
            case .day:
                return calendar.startOfDay(for: date)
            case .week:
                return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) ?? date
            case .month:
                return calendar.date(from: calendar.dateComponents([.year, .month], from: date)) ?? date
            }
        }

        // Group sales
        let groupedSales = Dictionary(grouping: repository.sales) {
            groupingKey(for: $0.timestamp)
        }

        var profitResult: [DailyProfitData] = []

        for (key, sales) in groupedSales {
            let items = sales.flatMap { $0.products }
            let revenue = items.reduce(0) { $0 + $1.price }
            let cost = items.reduce(0) { $0 + ($1.costPrice ?? 0) }
            let expense = repository.expense(for: key)

            let entry = DailyProfitData(
                date: key,
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

        expenseData = repository.dailyExpenses
            .map { entry in
                let grouped = groupingKey(for: entry.date)
                return (grouped, entry.entries)
            }
            .reduce(into: [Date: [ExpenseEntry]]()) { dict, pair in
                dict[pair.0, default: []] += pair.1
            }
            .map { (date, entries) in
                ExpenseSummary(
                    date: date,
                    total: entries.reduce(0) { $0 + $1.amount },
                    entries: entries.count
                )
            }
            .sorted(by: { $0.date < $1.date })
    }

    func shortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        switch groupingMode {
        case .day: formatter.dateFormat = "dd MMM"
        case .week: formatter.dateFormat = "'Week of' dd MMM"
        case .month: formatter.dateFormat = "MMM yyyy"
        }
        return formatter.string(from: date)
    }
}

//
//  DailyExpenseEntryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct DailyExpenseEntryView: View {
    @ObservedObject var repository: LocalSalesRepository

    @State private var expenseAmount: String = ""
    @State private var note: String = ""
    @State private var selectedDate: Date = Date()
    @State private var appliedFilterDate: Date = Date()
    @State private var filterMode: FilterMode = .all

    enum FilterMode: String, CaseIterable, Identifiable {
        case all = "All"
        case date = "Date"
        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                // MARK: - Add Expense Section
                Section(header: Text("Add New Expense")) {
                    DatePicker("Date", selection: $selectedDate, displayedComponents: .date)

                    TextField("Amount", text: $expenseAmount)
                        .keyboardType(.decimalPad)

                    TextField("Note", text: $note)

                    Button(action: {
                        addExpense()
                    }) {
                        Text("Add Expense")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isInputValid ? Color.accentColor : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(!isInputValid)
                }

                // MARK: - Filter Section
                Section {
                    Picker("Filter", selection: $filterMode) {
                        ForEach(FilterMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    if filterMode == .date {
                        DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)

                        Button("Apply Date Filter") {
                            appliedFilterDate = selectedDate
                        }
                        .frame(maxWidth: .infinity)
                    }
                }

                // MARK: - Expenses Display Section
                Section(header: Text("Expenses")) {
                    let displayExpenses: [DailyExpense] = {
                        switch filterMode {
                        case .all:
                            return repository.dailyExpenses.sorted(by: { $0.date > $1.date })
                        case .date:
                            return repository.dailyExpenses.filter {
                                Calendar.current.isDate($0.date, inSameDayAs: appliedFilterDate)
                            }.sorted(by: { $0.date > $1.date })
                        }
                    }()

                    if displayExpenses.isEmpty {
                        Text("No expenses recorded.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(displayExpenses) { day in
                            Section(header: Text(formatted(date: day.date))) {
                                ForEach(Array(day.entries.enumerated()), id: \.element.id) { entryIndex, entry in
                                    HStack {
                                        Text(entry.note)
                                        Spacer()
                                        Text("₹\(entry.amount, specifier: "%.2f")")
                                    }
                                }
                                .onDelete { indexSet in
                                    deleteExpenses(for: day.date, at: indexSet)
                                }

                                HStack {
                                    Text("Total")
                                        .fontWeight(.bold)
                                    Spacer()
                                    let total = day.entries.reduce(0) { $0 + $1.amount }
                                    Text("₹\(total, specifier: "%.2f")")
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Daily Expenses")
            .toolbar {
                EditButton()
            }
        }
    }

    private var isInputValid: Bool {
        Double(expenseAmount) != nil && !note.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func addExpense() {
        guard let amount = Double(expenseAmount) else { return }

        repository.addExpense(for: selectedDate, amount: amount, note: note)
        expenseAmount = ""
        note = ""
    }

    private func deleteExpenses(for date: Date, at offsets: IndexSet) {
        if let index = repository.dailyExpenses.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }) {
            repository.dailyExpenses[index].entries.remove(atOffsets: offsets)

            if repository.dailyExpenses[index].entries.isEmpty {
                repository.dailyExpenses.remove(at: index)
            }

            repository.saveAll()
        }
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}




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

                // MARK: - Existing Expenses Section
                Section(header: Text("Expenses on \(formatted(date: selectedDate))")) {
                    let expenses = repository.getExpenses(for: selectedDate)

                    if expenses.isEmpty {
                        Text("No expenses recorded.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(expenses) { expense in
                            HStack {
                                Text(expense.note)
                                Spacer()
                                Text("₹\(expense.amount, specifier: "%.2f")")
                            }
                        }
                        .onDelete { indexSet in
                            deleteExpenses(at: indexSet)
                        }

                        HStack {
                            Text("Total")
                                .fontWeight(.bold)
                            Spacer()
                            Text("₹\(repository.expense(for: selectedDate), specifier: "%.2f")")
                                .fontWeight(.bold)
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

    private func deleteExpenses(at offsets: IndexSet) {
        if let index = repository.dailyExpenses.firstIndex(where: {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }) {
            repository.dailyExpenses[index].entries.remove(atOffsets: offsets)

            // Remove the entire date if no entries left
            if repository.dailyExpenses[index].entries.isEmpty {
                repository.dailyExpenses.remove(at: index)
            }
        }
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}



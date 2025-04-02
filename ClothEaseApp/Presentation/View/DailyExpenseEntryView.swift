//
//  DailyExpenseEntryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct DailyExpenseEntryView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var repository: LocalSalesRepository

    @State private var selectedDate: Date = Date()
    @State private var expenseAmount: String = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)

                TextField("Expense Amount", text: $expenseAmount)
                    .keyboardType(.decimalPad)

                Button("Save Expense") {
                    if let amount = Double(expenseAmount) {
                        repository.addOrUpdateExpense(for: selectedDate, amount: amount)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Daily Expense")
        }
        .onAppear {
            let existing = repository.expense(for: selectedDate)
            if existing > 0 {
                expenseAmount = String(format: "%.2f", existing)
            }
        }
    }
}


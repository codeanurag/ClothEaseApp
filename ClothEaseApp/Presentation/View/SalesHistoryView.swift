//
//  SalesHistoryView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SalesHistoryView: View {
    @StateObject var viewModel: SalesHistoryViewModel
    @State private var isShowingNewSale = false

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.filteredSales, id: \.id) { sale in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(sale.customer.name)
                                        .font(.headline)

                                    Spacer()

                                    NavigationLink(
                                        destination: SalesEntryView(
                                            viewModel: SalesEntryViewModel(
                                                addSaleUseCase: AddSaleUseCase(repository: viewModel.repository),
                                                editing: sale
                                            )
                                        )
                                    ) {
                                        Image(systemName: "pencil")
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.blue)
                                    }
                                }

                                Text("📦 \(sale.products.map { $0.name }.joined(separator: ", "))")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("🕒 \(formattedDate(sale.timestamp))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Sales History")
                .onAppear {
                    debugDuplicateIDs()
                }
            }

            // Floating Button Overlay
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    FloatingButton(action: {
                        isShowingNewSale = true
                    }, icon: "plus")
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                }
            }
        }
        .sheet(isPresented: $isShowingNewSale) {
            SalesEntryView(
                viewModel: SalesEntryViewModel(
                    addSaleUseCase: AddSaleUseCase(repository: viewModel.repository)
                )
            )
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func debugDuplicateIDs() {
        let ids = viewModel.filteredSales.map { $0.id }
        let duplicateIDs = Dictionary(grouping: ids, by: { $0 })
            .filter { $1.count > 1 }
            .keys

        if !duplicateIDs.isEmpty {
            print("⚠️ Duplicate Sale IDs found: \(duplicateIDs)")
        }
    }
}



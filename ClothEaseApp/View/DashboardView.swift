//
//  DashboardView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                NavigationLink(destination: SalesEntryView()) {
                    dashboardButtonLabel("➕ New Sale")
                }

                NavigationLink(destination: SalesHistoryView()) {
                    dashboardButtonLabel("📊 Sales History")
                }

                NavigationLink(destination: CustomerListView()) {
                    dashboardButtonLabel("👥 Customer List")
                }
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }

    private func dashboardButtonLabel(_ title: String) -> some View {
        Text(title)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}


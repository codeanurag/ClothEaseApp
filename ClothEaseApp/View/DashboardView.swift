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
            VStack(spacing: 20) {
                NavigationLink("New Sale", destination: Text("New Sale Screen"))
                NavigationLink("Sales History", destination: Text("Sales History"))
                NavigationLink("Customer List", destination: Text("Customer List"))
            }
            .navigationTitle("Dashboard")
        }
    }
}

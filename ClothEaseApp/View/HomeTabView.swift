//
//  HomeTabView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct HomeTabView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("No sales yet.")
                    .foregroundColor(.gray)
                    .padding()
                Spacer()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SalesEntryView()) {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
        }
    }
}

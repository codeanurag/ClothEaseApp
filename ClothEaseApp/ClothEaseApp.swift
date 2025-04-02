//
//  ClothEaseApp.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI
@main
struct ClothEaseApp: App {
    @AppStorage("userPasscode") var userPasscode: String = ""
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false
    @State private var showDashboard = false

    var body: some Scene {
        WindowGroup {
            if showDashboard {
                MainTabView()
            } else if !hasCompletedOnboarding || userPasscode.isEmpty {
                NavigationStack {
                    SetPasscodeView { showDashboard = true }
                }
            } else {
                EnterPasscodeView { showDashboard = true }
            }
        }
    }
}




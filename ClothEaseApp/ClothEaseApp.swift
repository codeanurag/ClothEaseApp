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
    @AppStorage("passcodeEnabled") var passcodeEnabled: Bool = false
    @State private var showDashboard = false

    init() {
        UIView.appearance().overrideUserInterfaceStyle = .dark
    }

    var body: some Scene {
        WindowGroup {
            if showDashboard {
                MainTabView()
            } else if !hasCompletedOnboarding || (passcodeEnabled && userPasscode.isEmpty) {
                NavigationStack {
                    SetPasscodeView { showDashboard = true }
                }
            } else if passcodeEnabled {
                EnterPasscodeView { showDashboard = true }
            } else {
                MainTabView()
            }
        }
    }
}





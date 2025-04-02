//
//  SetPasscodeView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SetPasscodeView: View {
    @AppStorage("userPasscode") private var storedPasscode: String = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var passcode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var showConfirmField = false
    @State private var showError = false
    @FocusState private var isFocused: Bool

    var onSuccess: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text(showConfirmField ? "Confirm Passcode" : "Set Passcode")
                .font(.title2)
                .bold()

            SecureDotsView(code: showConfirmField ? confirmPasscode : passcode)

            SecureField("", text: showConfirmField ? $confirmPasscode : $passcode)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: showConfirmField ? confirmPasscode : passcode) {
                    handleTyping()
                }
                .frame(width: 0, height: 0) // invisible but keeps keyboard alive
                .opacity(0)

            if showError {
                Text("Passcodes must match and be 4 digits.")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            isFocused = true
        }
    }

    private func handleTyping() {
        if !showConfirmField && passcode.count == 4 {
            showConfirmField = true
            isFocused = true
        } else if showConfirmField && confirmPasscode.count == 4 {
            validatePasscode()
        }
    }

    private func validatePasscode() {
        guard passcode == confirmPasscode else {
            showError = true
            confirmPasscode = ""
            return
        }

        storedPasscode = passcode
        hasCompletedOnboarding = true
        onSuccess()
    }
}



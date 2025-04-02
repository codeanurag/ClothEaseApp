//
//  ConfirmPasscodeView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct ConfirmPasscodeView: View {
    let passcode: String
    @AppStorage("userPasscode") private var storedPasscode: String = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var confirmCode = ""
    @State private var showError = false
    @FocusState private var isFocused: Bool

    var onSuccess: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text("Confirm Passcode")
                .font(.title2)
                .bold()

            SecureDotsView(code: confirmCode)

            SecureField("", text: $confirmCode)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: confirmCode) { _ in
                    if confirmCode.count == 4 {
                        validate()
                    }
                }
                .opacity(0)
                .frame(width: 0, height: 0)

            if showError {
                Text("Passcodes do not match")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
        .onAppear { isFocused = true }
    }

    private func validate() {
        if confirmCode == passcode {
            storedPasscode = passcode
            hasCompletedOnboarding = true
            onSuccess()
        } else {
            confirmCode = ""
            showError = true
        }
    }
}

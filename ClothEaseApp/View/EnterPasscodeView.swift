//
//  EnterPasscodeView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

struct EnterPasscodeView: View {
    @State private var input: String = ""
    @AppStorage("userPasscode") private var storedPasscode: String = "1234"
    @FocusState private var isFocused: Bool
    @State private var showError: Bool = false

    var onSuccess: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text("Enter Passcode")
                .font(.title2)
                .bold()

            SecureDotsView(code: input)

            SecureField("", text: $input)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: input) {
                    if input.count > 4 {
                        input = String(input.prefix(4))
                    }

                    if input.count == 4 {
                        verifyPasscode()
                    }
                }
                .opacity(0) // invisible input but keeps keyboard open

            if showError {
                Text("Incorrect passcode. Try again.")
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

    private func verifyPasscode() {
        if input == storedPasscode {
            onSuccess()
        } else {
            input = ""
            showError = true
        }
    }
}


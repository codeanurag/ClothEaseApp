//
//  SetPasscodeView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//

import SwiftUI

struct SetPasscodeView: View {
    @State private var passcode: String = ""
    @FocusState private var isFocused: Bool

    var onSuccess: () -> Void

    var body: some View {
        VStack(spacing: 30) {
            Text("Set Passcode")
                .font(.title2)
                .bold()

            SecureDotsView(code: passcode)

            SecureField("", text: $passcode)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .onChange(of: passcode) { _ in
                    if passcode.count == 4 {
                        // Navigate to confirmation
                        isFocused = false
                    }
                }
                .opacity(0)
                .frame(width: 0, height: 0)

            NavigationLink(
                destination: ConfirmPasscodeView(passcode: passcode, onSuccess: onSuccess),
                isActive: .constant(passcode.count == 4),
                label: {
                    EmptyView()
                }
            )

            Spacer()
        }
        .padding()
        .onAppear { isFocused = true }
    }
}


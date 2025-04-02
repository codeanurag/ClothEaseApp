//
//  PasscodeViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

class PasscodeViewModel: ObservableObject {
    @Published var input: String = ""
    @Published var isUnlocked: Bool = false
    @AppStorage("userPasscode") private var storedPasscode: String = "1234"

    func handleInput(_ digit: String) {
        guard input.count < 4 else { return }
        input.append(digit)
        if input.count == 4 {
            verifyPasscode()
        }
    }

    func deleteLast() {
        guard !input.isEmpty else { return }
        input.removeLast()
    }

    private func verifyPasscode() {
        if input == storedPasscode {
            isUnlocked = true
        } else {
            input = ""
        }
    }
}

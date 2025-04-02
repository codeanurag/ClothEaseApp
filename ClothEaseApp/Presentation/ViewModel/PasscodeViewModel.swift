//
//  PasscodeViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import Foundation
import SwiftUI

class PasscodeViewModel: ObservableObject {
    @Published var input: String = ""
    @AppStorage("userPasscode") private var storedPasscode: String = "1234"

    func handleInput(_ digit: String, onSuccess: @escaping () -> Void) {
        guard input.count < 4 else { return }
        input.append(digit)
        if input.count == 4 {
            verifyPasscode(onSuccess: onSuccess)
        }
    }

    func deleteLast() {
        guard !input.isEmpty else { return }
        input.removeLast()
    }

    private func verifyPasscode(onSuccess: @escaping () -> Void) {
        if input == storedPasscode {
            onSuccess()
        } else {
            input = ""
        }
    }
}


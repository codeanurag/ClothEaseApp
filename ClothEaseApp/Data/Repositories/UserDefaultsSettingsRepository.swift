//
//  UserDefaultsSettingsRepository.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

class UserDefaultsSettingsRepository: UserSettingsRepository {
    @AppStorage("userPasscode") private var storedPasscode: String = "1234"

    func getPasscode() -> String {
        return storedPasscode
    }

    func updatePasscode(_ newPasscode: String) {
        storedPasscode = newPasscode
    }
}

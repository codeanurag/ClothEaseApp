//
//  UserSettingsRepository.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


protocol UserSettingsRepository {
    func getPasscode() -> String
    func updatePasscode(_ newPasscode: String)
}

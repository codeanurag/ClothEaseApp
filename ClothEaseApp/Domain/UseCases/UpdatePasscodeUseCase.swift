//
//  UpdatePasscodeUseCase.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class UpdatePasscodeUseCase {
    private let repository: UserSettingsRepository

    init(repository: UserSettingsRepository) {
        self.repository = repository
    }

    func execute(newPasscode: String) {
        repository.updatePasscode(newPasscode)
    }
}

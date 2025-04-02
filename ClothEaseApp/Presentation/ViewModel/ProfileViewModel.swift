//
//  ProfileViewModel.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import Foundation

class ProfileViewModel: ObservableObject {
    @Published var newPasscode = ""
    @Published var confirmPasscode = ""
    @Published var showSuccess = false
    @Published var showError = false

    private let updatePasscodeUseCase: UpdatePasscodeUseCase

    init(updatePasscodeUseCase: UpdatePasscodeUseCase) {
        self.updatePasscodeUseCase = updatePasscodeUseCase
    }

    func updatePasscode() {
        guard newPasscode == confirmPasscode, newPasscode.count == 4 else {
            showError = true
            return
        }

        updatePasscodeUseCase.execute(newPasscode: newPasscode)

        newPasscode = ""
        confirmPasscode = ""
        showError = false
        showSuccess = true
    }
}

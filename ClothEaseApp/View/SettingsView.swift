//
//  SettingsView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("userPasscode") private var storedPasscode: String = "1234"
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var showAlert = false

    var body: some View {
        Form {
            Section(header: Text("Change Passcode")) {
                SecureField("New Passcode", text: $newPasscode)
                    .keyboardType(.numberPad)
                SecureField("Confirm Passcode", text: $confirmPasscode)
                    .keyboardType(.numberPad)

                Button("Save New Passcode") {
                    changePasscode()
                }
            }
        }
        .navigationTitle("Settings")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Passcode Updated"), message: Text("Your new passcode is set."), dismissButton: .default(Text("OK")))
        }
    }

    private func changePasscode() {
        guard newPasscode.count == 4,
              newPasscode == confirmPasscode else { return }

        storedPasscode = newPasscode
        newPasscode = ""
        confirmPasscode = ""
        showAlert = true
    }
}

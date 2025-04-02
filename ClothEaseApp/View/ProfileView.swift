//
//  ProfileView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct ProfileView: View {
    @AppStorage("userPasscode") private var storedPasscode: String = ""
    @State private var newPasscode: String = ""
    @State private var confirmPasscode: String = ""
    @State private var showSuccess = false
    @State private var showError = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Change Passcode")) {
                    SecureField("New Passcode", text: $newPasscode)
                        .keyboardType(.numberPad)
                    SecureField("Confirm Passcode", text: $confirmPasscode)
                        .keyboardType(.numberPad)

                    Button("Update Passcode") {
                        updatePasscode()
                    }
                    .disabled(newPasscode.count != 4 || confirmPasscode.count != 4)
                }

                if showError {
                    Text("Passcodes must match and be 4 digits.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Profile")
            .alert("Success", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Passcode updated successfully.")
            }
        }
    }

    private func updatePasscode() {
        guard newPasscode == confirmPasscode, newPasscode.count == 4 else {
            showError = true
            return
        }

        storedPasscode = newPasscode
        newPasscode = ""
        confirmPasscode = ""
        showError = false
        showSuccess = true
    }
}

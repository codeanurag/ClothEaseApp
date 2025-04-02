//
//  ProfileView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Change Passcode")) {
                    SecureField("New Passcode", text: $viewModel.newPasscode)
                        .keyboardType(.numberPad)

                    SecureField("Confirm Passcode", text: $viewModel.confirmPasscode)
                        .keyboardType(.numberPad)

                    Button("Update Passcode") {
                        viewModel.updatePasscode()
                    }
                    .disabled(viewModel.newPasscode.count != 4 || viewModel.confirmPasscode.count != 4)
                }

                if viewModel.showError {
                    Text("Passcodes must match and be 4 digits.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .navigationTitle("Profile")
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Passcode updated successfully.")
            }
        }
    }
}

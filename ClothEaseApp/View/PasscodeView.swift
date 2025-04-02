//
//  PasscodeView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//
import SwiftUI

// MARK: - Views
struct PasscodeView: View {
    @StateObject private var viewModel = PasscodeViewModel()

    var body: some View {
        VStack(spacing: 40) {
            Text("Enter Passcode")
                .font(.largeTitle)
                .bold()

            HStack(spacing: 20) {
                ForEach(0..<4) { index in
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .fill(index < viewModel.input.count ? Color.black : Color.clear)
                        )
                }
            }

            VStack(spacing: 10) {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(1...3, id: \ .self) { col in
                            let number = row * 3 + col
                            PasscodeButton(label: "\(number)") {
                                viewModel.handleInput("\(number)")
                            }
                        }
                    }
                }

                HStack {
                    PasscodeButton(label: "Del") {
                        viewModel.deleteLast()
                    }
                    PasscodeButton(label: "0") {
                        viewModel.handleInput("0")
                    }
                    Spacer().frame(width: 60)
                }
            }

            Spacer()
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.isUnlocked) {
            DashboardView()
        }
    }
}

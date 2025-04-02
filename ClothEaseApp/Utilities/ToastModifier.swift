//
//  ToastModifier.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//


import SwiftUI

struct ToastModifier: ViewModifier {
    let message: String
    @Binding var isShowing: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isShowing {
                VStack {
                    Spacer()

                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(10)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 30)
                }
                .animation(.easeInOut, value: isShowing)
            }
        }
    }
}

extension View {
    func toast(message: String, isShowing: Binding<Bool>) -> some View {
        self.modifier(ToastModifier(message: message, isShowing: isShowing))
    }
}

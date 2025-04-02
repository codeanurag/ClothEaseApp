//
//  SecureDotsView.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 02/04/25.
//
import SwiftUI

struct SecureDotsView: View {
    var code: String

    var body: some View {
        HStack(spacing: 20) {
            ForEach(0..<4, id: \.self) { index in
                Circle()
                    .fill(index < code.count ? Color.black : Color(.systemGray3))
                    .frame(width: 16, height: 16)
            }
        }
    }
}

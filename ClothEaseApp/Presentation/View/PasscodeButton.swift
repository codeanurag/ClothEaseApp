//
//  PasscodeButton.swift
//  ClothEaseApp
//
//  Created by Anurag Pandit on 01/04/25.
//

import SwiftUI
struct PasscodeButton: View {
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(Color(.systemGray5))
                .clipShape(Circle())
        }
    }
}

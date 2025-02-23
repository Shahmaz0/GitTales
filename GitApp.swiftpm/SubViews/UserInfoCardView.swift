//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 16/02/25.
//

import SwiftUI

struct UserInfoCardView: View {
    var username: String
    
    var body: some View {
        HStack {
            Text(username)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white)
                .frame(width: 100, height: 30) // Fixed width and height
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1) // White border
                )
        }
    }
}

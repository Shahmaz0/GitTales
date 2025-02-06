//
//  File.swift
//  GitApp
//
//  Created by Shahma Ansari on 06/02/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isLoading = false
    
    var body: some View {
        Rectangle()
            .frame(width: 200, height: 2)
            .foregroundColor(.white.opacity(0.3))
            .overlay(
                Rectangle()
                    .frame(width: 50, height: 2)
                    .foregroundColor(.white)
                    .offset(x: isLoading ? 150 : -150)
            )
            .onAppear {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    isLoading = true
                }
            }
    }
}

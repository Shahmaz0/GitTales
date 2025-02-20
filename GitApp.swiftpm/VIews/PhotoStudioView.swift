//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 19/02/25.
//

import SwiftUI

struct PhotoStudioView: View {
    @Binding var textInput: String
    @Binding var commandHistory: [String]
    var onSubmit: () -> Void
    
    var body: some View {
        ZStack {
            // Background Image
            Image("photoStudio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Circles placed on chairs
            ForEach(0..<4, id: \.self) { index in
                ZStack {
                    Circle()
                        .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                        .frame(width: 100, height: 100)
                    
                    VStack(spacing: 10) {
                        Image("swiftLogo")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        Text("File \(index + 1)")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(.bottom, 10)
                    }
                    .frame(width: 120, height: 50)
                }
                .offset(x: CGFloat(index) * 100 + 110, y: -CGFloat(index) * 40 - 105) // Adjust offsets to align with chairs
                .rotationEffect(.degrees(35)) // Rotate to match chair inclination
            }
            
            VStack {
                Spacer()
                
                // Terminal-like text field
                TerminalView(textInput: $textInput, commandHistory: $commandHistory, onSubmit: onSubmit)
                
                Spacer().frame(height: 80)
            }
        }
    }
}

// preview
struct PhotoStudioView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStudioView(
            textInput: .constant(""),
            commandHistory: .constant(["git init", "git branch main"]),
            onSubmit: {}
        )
    }
}

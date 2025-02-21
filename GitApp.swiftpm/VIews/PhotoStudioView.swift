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
    
    @State private var showStatusImage: Bool = false
    @State private var isStaged: Bool = false // New state for git add animation
    
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
                .offset(
                    x: isStaged ? -400 : (CGFloat(index) * 100 + 110),
                    y: isStaged ? UIScreen.main.bounds.height / 2 - 500 : (-CGFloat(index) * 40 - 105)
                )
                .rotationEffect(.degrees(isStaged ? 0 : 35))
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStaged)
            }
            
            VStack {
                Spacer()
                
                // Terminal-like text field
                TerminalView(textInput: $textInput, commandHistory: $commandHistory, onSubmit: {
                    handleCommand()
                })
                
                Spacer().frame(height: 80)
            }
            
            // Overlay Image
            if showStatusImage {
                Image("Image")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.7)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: showStatusImage)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                showStatusImage = false
                            }
                        }
                    }
            }
        }
    }
    
    private func handleCommand() {
        if !textInput.isEmpty {
            commandHistory.append(textInput)
            
            let command = textInput.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if command == "git status" {
                withAnimation {
                    showStatusImage = true
                }
            } else if command == "git add ." {
                withAnimation {
                    isStaged = true
                }
            }
            
            textInput = ""
        }
    }
}


// Preview remains the same
struct PhotoStudioView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStudioView(
            textInput: .constant(""),
            commandHistory: .constant(["git init", "git branch main"]),
            onSubmit: {}
        )
    }
}

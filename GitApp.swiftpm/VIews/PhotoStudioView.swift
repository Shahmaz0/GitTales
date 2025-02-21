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
    @State private var isStagedAndAligned: Bool = false // New state to track if files are in staged area and aligned horizontally
    
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
                        .frame(width: isStagedAndAligned ? 70 : 100, height: isStagedAndAligned ? 70 : 100) // Animate size change
                        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isStagedAndAligned)
                    
                    VStack(spacing: isStagedAndAligned ? 5 : 10) {
                        Image("swiftLogo")
                            .resizable()
                            .frame(width: isStagedAndAligned ? 40 : 70, height: isStagedAndAligned ? 40 : 70) // Adjust image size
                            .foregroundColor(.white)
                            .padding(.top, 10)
                        Text("File \(index + 1)")
                            .foregroundColor(.white)
                            .font(.system(size: isStagedAndAligned ? 12 : 14)) // Adjust font size
                            .padding(.bottom, (isStagedAndAligned ? 15 : 15))
                    }
                    .frame(width: isStagedAndAligned ? 80 : 120, height: isStagedAndAligned ? 30 : 50) // Adjust container size
                }
                .offset(
                    x: isStaged ? (isStagedAndAligned ? CGFloat(index) * 80 - 525 : -400) : (CGFloat(index) * 100 + 110),
                    y: isStaged ? (isStagedAndAligned ? UIScreen.main.bounds.height / 6 - 200 : UIScreen.main.bounds.height / 2 - 500) : (-CGFloat(index) * 40 - 105)
                )
                .rotationEffect(.degrees(isStaged ? (isStagedAndAligned ? 0 : 0) : 35))
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStaged)
                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStagedAndAligned)
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
                    .opacity(0.5)
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
            } else if command == "git add ." || command == "git stash pop" {
                withAnimation {
                    isStaged = true
                }
                
                // After the initial animation, align the circles horizontally and resize them
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isStagedAndAligned = true
                    }
                }
            } else if (command == "git stash") {
                withAnimation {
                    isStaged = false
                    isStagedAndAligned = false
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


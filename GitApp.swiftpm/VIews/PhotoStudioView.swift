import SwiftUI

struct PhotoStudioView: View {
    @ObservedObject var sharedData: SharedData
    @Binding var textInput: String
    @Binding var commandHistory: [String]
    var onSubmit: () -> Void
    
    @State private var showStatusImage: Bool = false
    @State private var isStaged: Bool = true
    @State private var isStagedAndAligned: Bool = true
    @State private var showInitialImage: Bool = true
    @State private var showFlash: Bool = false
    @State private var showImageFromLeft: Bool = true // New state for the image coming from the left
    @State private var imageOffset: CGFloat = -UIScreen.main.bounds.width // New state for the image's horizontal offset

    var body: some View {
        ZStack {
            // Background Image
            Image("photoStudio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Flash Effect
            if showFlash {
                Rectangle()
                    .fill(Color.white)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: showFlash)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation {
                                showFlash = false
                                showImageFromLeft = true // Trigger the image to come from the left
                            }
                        }
                    }
            }
            
            // Image coming from the left
            if showImageFromLeft {
                Image("gallery") // Replace with your actual image name
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 400) // Adjust size as needed
                    .offset(x: imageOffset, y: 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1)) {
                            imageOffset = 20 // Move the image to 20 points from the left
                        }
                    }
                    .position(x: 60, y: UIScreen.main.bounds.height - 150) // Position the image 20 points from the bottom
            }
            
            // Circles placed on chairs
            ForEach(0..<4, id: \.self) { index in
                CircleView(
                    index: index,
                    isStaged: isStaged,
                    isStagedAndAligned: isStagedAndAligned
                )
            }
            
            VStack {
                Spacer()
                
                // Terminal-like text field
                TerminalView(
                    textInput: $textInput,
                    commandHistory: $commandHistory,
                    sharedData: sharedData,
                    onSubmit: handleCommand
                )
                
                Spacer().frame(height: 80)
            }
            
            // Initial Image (Shown for 5 seconds when the view appears)
            if showInitialImage {
                VStack {
                    Spacer().frame(height: 20)
                    HStack {
                        Spacer()
                        Image("JHGitCheckout") // Replace with your actual image name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 450, height: 200) // Adjust size as needed
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.5), value: showInitialImage)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    withAnimation {
                                        showInitialImage = false
                                    }
                                }
                            }
                        Spacer()
                    }
                    Spacer()
                }
                .transition(.opacity) // Smooth transition
                .zIndex(1)
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
        .navigationBarBackButtonHidden(true)
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
            } else if command == "git stash" {
                withAnimation {
                    isStaged = false
                    isStagedAndAligned = false
                }
            } else if command == "git commit -m 'photos clicked'" {
                // Trigger the flash effect
                withAnimation {
                    showFlash = true
                }
            }
            
            textInput = ""
        }
    }
}

struct PhotoStudioView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoStudioView(
            sharedData: SharedData(),
            textInput: .constant(""),
            commandHistory: .constant(["git init", "git branch main"]),
            onSubmit: {}
        )
    }
}

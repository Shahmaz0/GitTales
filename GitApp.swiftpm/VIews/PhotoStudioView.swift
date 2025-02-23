//
//  PhotoStudioView.swift
//  GitApp
//
//  Created by Shahma Ansari on 19/02/25.
//
import SwiftUI

struct PhotoStudioView: View {
    @ObservedObject var sharedData: SharedData
    @Binding var textInput: String
    @Binding var commandHistory: [String]
    var onSubmit: () -> Void
    
    @State private var showStatusImage: Bool = false
    @State private var isStaged: Bool = false
    @State private var isStagedAndAligned: Bool = false
    @State private var showInitialImage: Bool = true
    @State private var showFlash: Bool = false
    @State private var showImageFromLeft: Bool = false
    @State private var imageOffset: CGFloat = -UIScreen.main.bounds.width
    @State private var removeCircles: Bool = false
    @State private var showGitAddImage: Bool = false
    @State private var showGitCommitImage: Bool = false
    @State private var showPushImage: Bool = false
    @State private var showThankYouPopup: Bool = false

    var body: some View {
        ZStack {
            // Background Image
            Image("photoStudio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
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
                                removeCircles = true // Trigger circle removal
                                showImageFromLeft = true
                            }
                        }
                    }
            }
            
            if showImageFromLeft {
                Image("gallery")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 400)
                    .offset(x: imageOffset, y: 0)
                    .onAppear {
                        withAnimation(.easeOut(duration: 1)) {
                            imageOffset = 20
                        }
                    }
                    .position(x: 60, y: UIScreen.main.bounds.height - 150)
            }
            
            if !removeCircles {
                ForEach(0..<4, id: \.self) { index in
                    CircleView(
                        index: index,
                        isStaged: isStaged,
                        isStagedAndAligned: isStagedAndAligned,
                        removeCircles: $removeCircles
                    )
                }
            }
            
            VStack {
                Spacer()
                TerminalView(
                    textInput: $textInput,
                    commandHistory: $commandHistory,
                    sharedData: sharedData,
                    onSubmit: handleCommand
                )
                
                Spacer().frame(height: 80)
            }
            
            if showInitialImage {
                VStack {
                    Spacer().frame(height: 20)
                    HStack {
                        Spacer()
                        Image("JHGitCheckout")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 500, height: 250)
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
                .transition(.opacity)
                .zIndex(1)
            }
            
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
            
            if showGitAddImage {
                VStack {
                    Image("gitAdd")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 250)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showGitAddImage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                withAnimation {
                                    showGitAddImage = false
                                }
                            }
                        }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            }
            
            // Image for git commit
            if showGitCommitImage {
                VStack {
                    Image("gitCommit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 250)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showGitCommitImage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                withAnimation {
                                    showGitCommitImage = false
                                }
                            }
                        }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            }
          
            if showPushImage {
                VStack {
                    Image("gitPush")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 250)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showPushImage)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                                withAnimation {
                                    showPushImage = false
                                    showThankYouPopup = true
                                }
                            }
                        }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 20)
            }
          
            if showThankYouPopup {
                Color.black.opacity(0.5) // Semi-transparent background
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5), value: showThankYouPopup)
                
                VStack {
                    Image("thankYou") // Replace with your image name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 150) // Adjust size as needed
                        .transition(.scale)
                        .animation(.easeInOut(duration: 0.5), value: showThankYouPopup)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .transition(.scale)
                .animation(.easeInOut(duration: 0.5), value: showThankYouPopup)
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
              
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isStagedAndAligned = true
                    }
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showGitAddImage = true
                        }
                    }
                }
            } else if command == "git stash" {
                withAnimation {
                    isStaged = false
                    isStagedAndAligned = false
                }
            } else if command == "git commit -m 'photos clicked'" {
                withAnimation {
                    showFlash = true
                }
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { withAnimation {
                        showGitCommitImage = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                        withAnimation {
                            showGitCommitImage = false
                        }
                    }
                }
            } else if command == "git push" {
                withAnimation {
                    showImageFromLeft = false
                }
                
                withAnimation {
                    showPushImage = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    withAnimation {
                        showPushImage = false
                        showThankYouPopup = true
                    }
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

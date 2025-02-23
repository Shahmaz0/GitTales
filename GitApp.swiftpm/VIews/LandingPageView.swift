//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 20/02/25.
//

import SwiftUI

struct LandingPageView: View {
    @ObservedObject var sharedData: SharedData
    @State private var textInput: String = ""
    @State private var commandHistory: [String] = []
    @State private var showCircles: Bool = false // Initially hidden
    @State private var showHouseImage: Bool = false
    @State private var showStoreImage: Bool = false
    @State private var isGrouped: Bool = false
    @State private var navigateToNewPage: Bool = false
    @State private var showBackground: Bool = false // Controls background visibility
    @State private var showTextArea: Bool = true // Controls text area visibility
    @State private var showJHGitInitImage: Bool = false
    @State private var showGitBranchMainImage: Bool = false
    @State private var showCenterImage: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image (conditional visibility)
                if showBackground {
                    Image("background")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                        .transition(.opacity) // Smooth transition
                }

                // Snowfall Effect (conditional visibility)
                if showBackground {
                    SnowfallView()
                        .transition(.opacity) // Smooth transition
                }
                
                // JHGitInit Image (conditional visibility)
                if showJHGitInitImage {
                    VStack {
                        Spacer().frame(height: 20) // Positions the image 20 points from the top
                        HStack {
                            Spacer() // Centers the image horizontally
                            Image("JHInit")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 450, height: 200)
                            Spacer() // Centers the image horizontally
                        }
                        Spacer() // Pushes the HStack to the top
                    }
                    .transition(.opacity) // Smooth transition
                    .zIndex(1) // Ensure it appears on top
                }

                // gitBranchMain Image (conditional visibility)
                if showGitBranchMainImage {
                    VStack {
                        Spacer().frame(height: 20) // Positions the image 20 points from the top
                        HStack {
                            Spacer()
                            Image("gitBranchMain")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 400)
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }

                if showCenterImage {
                    VStack {
                        Spacer().frame(height: 20) // Positions the image 20 points from the top
                        HStack {
                            Spacer()
                            Image("gitCheckout") // Replace "centerImage" with your image asset name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 400)
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.opacity) // Smooth transition
                    .zIndex(3) // Ensure it appears on top
                }
                

                // Store Image (existing code)
                Image("store")
                    .resizable()
                    .frame(width: 400, height: 300)
                    .offset(x: showStoreImage ? 0 : UIScreen.main.bounds.width, y: 0)
                    .animation(.easeInOut(duration: 1.5), value: showStoreImage)
                    .position(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 1.9)

                // User Info Card (existing code)
                VStack {
                    HStack {
                        UserInfoCardView(username: "Shahma")
                        Spacer()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 80)
                .padding(.leading, 50)

                // Text Area (conditional visibility)
                if showTextArea {
                    Image("gitInit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 500, height: 400)
                        .transition(.opacity.combined(with: .scale))
                }

                VStack {
                    Spacer()

                    // Show circles only if git init was typed
                    if showCircles {
                        HStack(spacing: 40) {
                            ForEach(sharedData.fileNames.indices, id: \.self) { index in
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                                        .frame(width: 120, height: 120)

                                    VStack(spacing: 10) {
                                        Image("swiftLogo")
                                            .resizable()
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.white)
                                            .padding(.top, 10)
                                        Text(sharedData.fileNames[index])
                                            .foregroundColor(.white)
                                            .font(.system(size: 14))
                                            .padding(.bottom, 10)
                                    }
                                    .frame(width: 120, height: 120)
                                }
                                .offset(
                                    x: isGrouped ? UIScreen.main.bounds.width / 5 - CGFloat(index * 140) - 300 : 0,
                                    y: isGrouped ? -UIScreen.main.bounds.height / 3 + 150 : 0
                                )
                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: isGrouped)
                                .zIndex(isGrouped && !showHouseImage ? Double(sharedData.fileNames.count - index) : 0)
                                .opacity(isGrouped && !showHouseImage ? (index == 0 ? 1 : 0) : 1)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7), value: isGrouped)
                                .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: showHouseImage)
                            }
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width / 4)
                    }

                    // Terminal-like text field (existing code)
                    TerminalView(
                        textInput: $textInput,
                        commandHistory: $commandHistory,
                        sharedData: sharedData, onSubmit: handleCommand
                    )

                    Spacer().frame(height: 80)
                }
            }
            .navigationDestination(isPresented: $navigateToNewPage) {
                PhotoStudioView(
                    sharedData: sharedData,
                    textInput: $textInput,
                    commandHistory: $commandHistory,
                    onSubmit: handleCommand // Pass sharedData here
                )
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func handleCommand() {
        if !textInput.isEmpty {
            commandHistory.append(textInput)
            
            // Handle the "git init" command
            if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git init" {
                withAnimation {
                    showTextArea = false // Hide the text area
                }
                
                // Show background and snowfall after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showBackground = true
                        showCircles = true
                    }
                    
                    // Show JHGitInit image after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showJHGitInitImage = true
                        }
                        
                        // Hide JHGitInit image after 5 seconds
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            withAnimation {
                                showJHGitInitImage = false
                            }
                        }
                    }
                }
            }
            
            // Handle the "git branch photoStudio" command
            if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git branch photoStudio" {
                withAnimation {
                    showStoreImage = true
                }
                
                // After the store image animation is complete, show the gitBranchMain image
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showGitBranchMainImage = true
                    }
                    
                    // Hide the gitBranchMain image after 5 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showGitBranchMainImage = false
                            
                            // Show the center image after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showCenterImage = true
                                }
                            }
                        }
                    }
                }
            }
            
            // Handle the "git checkout photoStudio" command
            if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git checkout photoStudio" {
                // Hide the center image first
                withAnimation {
                    showCenterImage = false
                }
                
                // After the center image animation completes, start the git checkout animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        isGrouped = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation {
                            showHouseImage = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            navigateToNewPage = true
                        }
                    }
                    
                    // Show the store image
                    withAnimation {
                        showStoreImage = true
                    }
                }
            }
            
            // Handle the "git status" command
            if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git status" {
                // Show the image overlay in PhotoStudioView
                navigateToNewPage = true
            }
            
            textInput = ""
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView(sharedData: SharedData())
    }
}

//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 20/02/25.
//

import SwiftUI

struct LandingPageView: View {
    @ObservedObject var sharedData: SharedData // Use the passed SharedData instance
    @State private var textInput: String = ""
    @State private var commandHistory: [String] = []
    @State private var showCircles: Bool = false
    @State private var showHouseImage: Bool = false
    @State private var showStoreImage: Bool = false
    @State private var isGrouped: Bool = false
    @State private var navigateToNewPage: Bool = false
    @State private var showBackground: Bool = false
    @State private var showTextArea: Bool = true
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
                        .transition(.opacity)
                }

                // Snowfall Effect (conditional visibility)
                if showBackground {
                    SnowfallView()
                        .transition(.opacity)
                }

                // JHGitInit Image (conditional visibility)
                if showJHGitInitImage {
                    VStack {
                        Spacer().frame(height: 20)
                        HStack {
                            Spacer()
                            Image("JHInit")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 450, height: 200)
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }

                // gitBranchMain Image (conditional visibility)
                if showGitBranchMainImage {
                    VStack {
                        Spacer().frame(height: 20)
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
                        Spacer().frame(height: 20)
                        HStack {
                            Spacer()
                            Image("gitCheckout")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 500, height: 400)
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                    .zIndex(3)
                }

                // Store Image
                Image("store")
                    .resizable()
                    .frame(width: 400, height: 300)
                    .offset(x: showStoreImage ? 0 : UIScreen.main.bounds.width, y: 0)
                    .animation(.easeInOut(duration: 1.5), value: showStoreImage)
                    .position(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 1.9)

                // User Info Card
                VStack {
                    HStack {
                        UserInfoCardView(username: sharedData.username) // Use sharedData.username
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

                    // Terminal-like text field
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
                    onSubmit: handleCommand
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
                    showTextArea = false
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation {
                        showBackground = true
                        showCircles = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            showJHGitInitImage = true
                        }

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

                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showGitBranchMainImage = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation {
                            showGitBranchMainImage = false

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
                withAnimation {
                    showCenterImage = false
                }

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

                    withAnimation {
                        showStoreImage = true
                    }
                }
            }

            // Handle the "git status" command
            if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git status" {
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

import SwiftUI

struct LandingPageView: View {
    @ObservedObject var sharedData: SharedData
    @State private var textInput: String = ""
    @State private var commandHistory: [String] = []
    @State private var showCircles: Bool = true // Tracks whether to show the circles
    @State private var showHouseImage: Bool = false // Tracks whether to show the house image
    @State private var showStoreImage: Bool = false // Tracks whether to show the store image

    var body: some View {
        ZStack {
            // Background Image
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Store Image
            Image("store")
                .resizable()
                .frame(width: 400, height: 300)
                .offset(x: showStoreImage ? 0 : UIScreen.main.bounds.width, y: 0) // Start from the right side
                .animation(.easeInOut(duration: 1.5), value: showStoreImage) // Animate the transition
                .position(x: UIScreen.main.bounds.width / 4, y: UIScreen.main.bounds.height / 1.9) // Final position
            
            // Snowfall Effect
            SnowfallView()
            
            // User Info Card (Top-Left)
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
            
            VStack {
                Spacer()
                
                // Show circles only if git init was typed
                if showCircles {
                    HStack(spacing: 40) {
                        ForEach(sharedData.fileNames.indices, id: \.self) { index in
                            ZStack { // Remove .bottom alignment to center content
                                Circle()
                                    .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                                    .frame(width: 120, height: 120)
                                
                                VStack(spacing: 10) {
                                    Image("swiftLogo")
                                        .resizable()
                                        .frame(width: 70, height: 70) // Adjust size for better fit
                                        .foregroundColor(.white)
                                        .padding(.top, 10)
                                    Text(sharedData.fileNames[index])
                                        .foregroundColor(.white)
                                        .font(.system(size: 14))
                                        .padding(.bottom, 10) // Move text inside the bottom
                                }
                                .frame(width: 120, height: 120) // Ensures VStack fills the circle
                            }
                        }
                    }
                    .padding(.top, 5)
                    .padding(.leading, 10)
                }
                
                // Terminal-like text field
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(commandHistory, id: \.self) { command in
                            HStack(spacing: 0) {
                                PromptView()
                                Text(command)
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, design: .monospaced))
                            }
                        }
                        
                        // Text field with colored prompt
                        HStack(alignment: .top, spacing: 0) {
                            PromptView()
                            
                            TextField("Enter your command...", text: $textInput)
                                .foregroundColor(.white)
                                .font(.system(size: 12, design: .monospaced))
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.none)
                                .onSubmit {
                                    if !textInput.isEmpty {
                                        commandHistory.append(textInput)
                                        
                                        // Show circles only if "git init" is entered
                                        if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git init" {
                                            showCircles = true
                                        }
                                        
                                        // Show house image if "git checkout main" is entered
                                        if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git checkout main" {
                                            showHouseImage = true
                                        }
                                        
                                        // Show store image with animation if "git branch main" is entered
                                        if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git branch main" {
                                            withAnimation {
                                                showStoreImage = true
                                            }
                                        }
                                        
                                        // Hide store image with animation if "git branch -D main" is entered
                                        if textInput.trimmingCharacters(in: .whitespacesAndNewlines) == "git branch -D main" {
                                            withAnimation {
                                                showStoreImage = false
                                            }
                                        }
                                        
                                        textInput = "" // Clear input field
                                    }
                                }
                        }
                    }
                }
                .frame(width: 500, height: 130)
                .padding()
                .background(Color.black)
                .cornerRadius(30)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white, lineWidth: 1)
                )
                
                Spacer().frame(height: 50)
            }
        }
    }
}

struct LandingPageView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPageView(sharedData: SharedData())
    }
}

import SwiftUI

struct LandingPageView: View {
    @State private var textInput: String = ""
    @State private var commandHistory: [String] = []
    @State private var showCircles: Bool = false // Tracks whether to show the circles

    var body: some View {
        ZStack {
            // Background Image
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
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
                        ForEach(0..<4) { _ in
                            Circle()
                                .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                                .frame(width: 120, height: 120)
                                .padding(.bottom, 10)
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



// Terminal Prompt View with Colored Text
struct PromptView: View {
    var body: some View {
        HStack(spacing: 0) {
            Text("~ demo_Project ")
                .foregroundColor(Color(red: 105/255, green: 194/255, blue: 206/255)) // Green
            
            Text("git : (")
                .foregroundColor(.purple) // Yellow
            
            Text("main")
                .foregroundColor(.red) // Purple
            
            Text(") ")
                .foregroundColor(.purple) // Yellow
        }
        .font(.system(size: 12, design: .monospaced))
    }
}

struct SnowfallView: View {
    @State private var snowflakes: [Snowflake] = []
    
    var body: some View {
        ZStack {
            ForEach($snowflakes) { $snowflake in
                Text("❄️")
                    .font(.system(size: snowflake.size))
                    .position(x: snowflake.x, y: snowflake.y)
                    .opacity(snowflake.opacity)
            }
        }
        .onAppear {
            // Start snowfall animation
            startSnowfall()
        }
    }
    
    func startSnowfall() {
        // Timer to create new snowflakes
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            DispatchQueue.main.async {
                let screenWidth = UIScreen.main.bounds.width
                let snowflake = Snowflake(screenWidth: screenWidth)
                snowflakes.append(snowflake)
            }
        }
        
        // Timer to update snowflake positions (make them fall)
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            DispatchQueue.main.async {
                for index in snowflakes.indices {
                    snowflakes[index].fall()
                }
                
                // Remove snowflakes that have fallen off the screen
                snowflakes.removeAll { $0.y > UIScreen.main.bounds.height }
            }
        }
    }
}

struct Snowflake: Identifiable {
    let id = UUID()
    let size: CGFloat
    let x: CGFloat
    var y: CGFloat
    let opacity: Double
    let speed: Double
    
    init(screenWidth: CGFloat) {
        self.size = CGFloat.random(in: 10...20)
        self.x = CGFloat.random(in: 0...screenWidth)
        self.y = -50 // Start above the screen
        self.opacity = Double.random(in: 0.5...1.0)
        self.speed = Double.random(in: 2...5)
    }
    
    mutating func fall() {
        y += speed
    }
}

// Preview
#Preview {
    LandingPageView()
}

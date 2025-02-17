import SwiftUI

struct ContentView: View {
    @StateObject private var sharedData = SharedData()
    @State private var isLoading = false
    @State private var animationCount = 0
    @State private var showTextField = false
    @State private var username = ""
    @State private var projectName = ""
    @State private var isProjectNameFieldActive = false
    @State private var showAdditionalFields = false
    
    // Focus state for managing text field focus
    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case username
        case projectName
        case field1
        case field2
        case field3
        case field4
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Full-Screen Background Image
                Image("backgrounddim") // Replace with your image name
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    // GitHub logo
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)

                    // Loader animation
                    if !showTextField {
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame(width: 100, height: 2)
                                .foregroundColor(.white.opacity(0.3))
                            
                            Rectangle()
                                .frame(width: 50, height: 2)
                                .foregroundColor(.white)
                                .offset(x: isLoading ? 100 : -50)
                                .animation(.linear(duration: 1).repeatCount(3, autoreverses: false), value: isLoading)
                        }
                        .frame(width: 100, height: 2)
                        .clipped()
                        .onAppear {
                            startLoadingAnimation()
                        }
                    }
                    
                    // Username TextField with arrow button
                    if showTextField && !isProjectNameFieldActive {
                        VStack(spacing: 30) {
                            TextField("Your Name", text: $username)
                                .frame(width: 150, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .username)
                            
                            Button(action: {
                                isProjectNameFieldActive = true
                                focusedField = .projectName
                            }) {
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Project Name TextField with next button
                    if isProjectNameFieldActive && !showAdditionalFields {
                        VStack(spacing: 30) {
                            TextField("Project Name", text: $projectName)
                                .frame(width: 150, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .projectName)
                            
                            Button(action: {
                                showAdditionalFields = true
                            }) {
                                Image(systemName: "arrow.right.circle")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    // Additional Text Fields
                    if showAdditionalFields {
                        Label("Create File", systemImage: "pencil.circle")
                        VStack(spacing: 20) {
                            TextField(".swift", text: $sharedData.fileNames[0])
                                .frame(width: 200, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .field1)
                            
                            TextField(".xib", text: $sharedData.fileNames[1])
                                .frame(width: 200, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .field2)
                            
                            TextField(".gitignore", text: $sharedData.fileNames[2])
                                .frame(width: 200, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .field3)
                            
                            TextField(".swift", text: $sharedData.fileNames[3])
                                .frame(width: 200, height: 20)
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white, lineWidth: 1)
                                )
                                .multilineTextAlignment(.center)
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                                .focused($focusedField, equals: .field4)
                        }
                        
                        NavigationLink(destination: LandingPageView(sharedData: sharedData)) {
                            Image(systemName: "arrow.right.circle")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }

    func startLoadingAnimation() {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showTextField = true
            focusedField = .username
        }
    }
}

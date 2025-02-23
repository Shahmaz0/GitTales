import SwiftUI

struct OnboardingView: View {
    @State private var showLearnImage = true
    @State private var degree = 0.0
    @State private var shouldNavigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Full-Screen Background Image
                Image("backgrounddim")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                // Logo in top-left corner
                VStack {
                    HStack {
                        Image("logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.white)
                            .padding(.top, 80)
                            .padding(.leading, 50)
                        Spacer()
                    }
                    Spacer()
                }
                
                // Centered image with transition
                HStack(spacing: 20) {
                    if showLearnImage {
                        Image("Learn")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 600, height: 500)
                            .transition(.opacity.combined(with: .scale))
                    } else {
                        Image("Story")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 600, height: 500)
                            .transition(.opacity.combined(with: .scale))
                    }
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if showLearnImage {
                                // First click: Show Story image
                                showLearnImage.toggle()
                                degree += 360
                            } else {
                                // Second click: Navigate to next page
                                shouldNavigate = true
                            }
                        }
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(degree))
                    }
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                UserInfoView()
                    .navigationBarBackButtonHidden() // Hide the default back button
            }
            .navigationBarHidden(true) // Hide the navigation bar
        }
    }
}


#Preview {
    OnboardingView()
}

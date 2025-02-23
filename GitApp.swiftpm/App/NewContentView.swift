import SwiftUI

struct NewContentView: View {
    
    @State private var isLoading = false
    @State private var showNextPage = false // Controls whether to show the next page
    
    var body: some View {
        ZStack {
            // Full-Screen Background Image
            Image("backgrounddim") // Replace with your image name
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            if !showNextPage {
                // Splash Screen Content
                VStack(spacing: 40) {
                    // GitHub logo
                    Image("logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    // Loading Animation
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
            } else {
                // Next Page Content
                OnboardingView()
            }
        }
    }
    
    func startLoadingAnimation() {
        isLoading = true

        // Transition to the next page after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            showNextPage = true
        }
    }
}



#Preview {
    NewContentView()
}

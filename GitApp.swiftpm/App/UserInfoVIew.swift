import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let width: CGFloat
    var focusField: UserInfoView.Field?
    @FocusState.Binding var focusedField: UserInfoView.Field?
    
    var body: some View {
        TextField(placeholder, text: $text)
            .frame(width: width, height: 20)
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
            .focused($focusedField, equals: focusField ?? .username)
    }
}

struct UserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var sharedData = SharedData()
    @State private var username = ""
    @State private var projectName = ""
    @State private var isProjectNameFieldActive = false
    @State private var showAdditionalFields = false
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case username
        case projectName
        case field1
        case field2
        case field3
        case field4
    }
    
    private let fileExtensions = [".swift", ".xib", ".gitignore", ".swift"]
    
    private var mainLogo: some View {
        Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 70, height: 70)
            .foregroundColor(.white)
    }
    
    private var usernameField: some View {
        VStack(spacing: 30) {
            CustomTextField(
                placeholder: "Your Name",
                text: $username,
                width: 150,
                focusField: .username,
                focusedField: $focusedField
            )
            
            navigationArrowButton {
                isProjectNameFieldActive = true
                focusedField = .projectName
            }
        }
    }
    
    private var projectNameField: some View {
        VStack(spacing: 30) {
            CustomTextField(
                placeholder: "Project Name",
                text: $projectName,
                width: 150,
                focusField: .projectName,
                focusedField: $focusedField
            )
            
            navigationArrowButton {
                showAdditionalFields = true
            }
        }
    }
    
    private var additionalFields: some View {
        VStack(spacing: 20) {
            Label("Create files named after your friends.", systemImage: "pencil.circle")
                .foregroundColor(.white)
            
            ForEach(0..<4) { index in
                CustomTextField(
                    placeholder: fileExtensions[index],
                    text: $sharedData.fileNames[index],
                    width: 200,
                    focusField: [Field.field1, .field2, .field3, .field4][index],
                    focusedField: $focusedField
                )
            }
            
            NavigationLink(destination: LandingPageView(sharedData: sharedData)) {
                Image(systemName: "arrow.right.circle")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
    
    private func navigationArrowButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: "arrow.right.circle")
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
    }
    
    var body: some View {
        ZStack {
            Image("backgrounddim")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                VStack(spacing: 30) {
                    mainLogo
                    
                    if !isProjectNameFieldActive {
                        usernameField
                    }
                    
                    if isProjectNameFieldActive && !showAdditionalFields {
                        projectNameField
                    }
                    
                    if showAdditionalFields {
                        additionalFields
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
        }
        .navigationBarHidden(false)
    }
}

#Preview {
    UserInfoView()
}

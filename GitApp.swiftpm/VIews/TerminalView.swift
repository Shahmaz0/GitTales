//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 19/02/25.
//

import SwiftUI

struct TerminalView: View {
    @Binding var textInput: String
    @Binding var commandHistory: [String]
    var onSubmit: () -> Void
    
    var body: some View {
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
                            onSubmit()
                        }
                }
            }
        }
        .frame(width: 450, height: 117)
        .padding()
        .background(Color.black)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color.white, lineWidth: 1)
        )
    }
}

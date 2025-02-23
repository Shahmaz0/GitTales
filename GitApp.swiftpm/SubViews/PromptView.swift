//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 16/02/25.
//

import SwiftUI

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

#Preview {
    PromptView()
}

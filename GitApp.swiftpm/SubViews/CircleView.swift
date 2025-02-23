//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 21/02/25.
//

import SwiftUI

struct CircleView: View {
    var index: Int
    var isStaged: Bool
    var isStagedAndAligned: Bool
    @Binding var removeCircles: Bool
    
    @State private var scale: CGFloat = 1.0
    @State private var opacity: Double = 1.0
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                .frame(width: isStagedAndAligned ? 70 : 100, height: isStagedAndAligned ? 70 : 100)
                .scaleEffect(scale)
                .opacity(opacity)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isStagedAndAligned)
                .onChange(of: removeCircles) { newValue in
                    if newValue {
                        withAnimation(.easeOut(duration: 0.3)) {
                            scale = 1.5
                            opacity = 0
                        }
                    }
                }
            
            VStack(spacing: isStagedAndAligned ? 5 : 10) {
                Image("swiftLogo")
                    .resizable()
                    .frame(width: isStagedAndAligned ? 40 : 70, height: isStagedAndAligned ? 40 : 70)
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Text("File \(index + 1)")
                    .foregroundColor(.white)
                    .font(.system(size: isStagedAndAligned ? 12 : 14))
                    .padding(.bottom, (isStagedAndAligned ? 15 : 15))
            }
            .frame(width: isStagedAndAligned ? 80 : 120, height: isStagedAndAligned ? 30 : 50)
        }
        .offset(
            x: isStaged ? (isStagedAndAligned ? CGFloat(index) * 80 - 525 : -400) : (CGFloat(index) * 100 + 110),
            
            y: isStaged ? (isStagedAndAligned ? UIScreen.main.bounds.height / 6 - 200 : UIScreen.main.bounds.height / 2 - 500) : (-CGFloat(index) * 40 - 105))
        
        .rotationEffect(.degrees(isStaged ? (isStagedAndAligned ? 0 : 0) : 35))
        
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStaged)
        
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStagedAndAligned)
    }
}

//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 23/02/25.
//

import SwiftUI

struct CircleView: View {
    var index: Int
    var isStaged: Bool
    var isStagedAndAligned: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(red: 67/255, green: 67/255, blue: 67/255))
                .frame(width: isStagedAndAligned ? 70 : 100, height: isStagedAndAligned ? 70 : 100)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isStagedAndAligned)
            
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
            y: isStaged ? (isStagedAndAligned ? UIScreen.main.bounds.height / 6 - 200 : UIScreen.main.bounds.height / 2 - 500) : (-CGFloat(index) * 40 - 105)
        )
        .rotationEffect(.degrees(isStaged ? (isStagedAndAligned ? 0 : 0) : 35))
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStaged)
        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(Double(index) * 0.1), value: isStagedAndAligned)
    }
}


#Preview {
    CircleView(index: 0, isStaged: false, isStagedAndAligned: false)
}

//
//  SwiftUIView.swift
//  GitApp
//
//  Created by Shahma Ansari on 16/02/25.

import SwiftUI

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

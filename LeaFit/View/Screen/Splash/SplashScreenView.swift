//
//  SplashScreenView.swift
//  LeaFit
//
//  Created by Yonathan Hilkia on 14/06/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoScale = 0.8
    @State private var logoOpacity = 0.5
    @State private var textOffset: CGFloat = 50
    @State private var textOpacity = 0.0
    @State private var showProgressBar = false
    @State private var progress: CGFloat = 0.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            ZStack {
                Color(hex: "E1EEDF")
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    
                    // Your custom logo
                    Image("img-splashlogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250) // Increased size for better visibility
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                    
                    
                    Spacer()
                    
              
                    
                }
            }
            .onAppear {
                startAnimations()
            }
        }
    }
    
    private func startAnimations() {
        // Logo animation
        withAnimation(.easeInOut(duration: 1.0)) {
            logoScale = 1.0
            logoOpacity = 1.0
        }
        
        // Text animation - delayed
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeOut(duration: 0.8)) {
                textOffset = 0
                textOpacity = 1.0
            }
        }
        
        // Show progress bar
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showProgressBar = true
            }
        }
        
        // Navigate to main app
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.5)) {
                isActive = true
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

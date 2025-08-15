//
//  SplashScreenView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-14.
//

import SwiftUI

struct SplashScreenView: View {
    
    @State private var isAnimating = false
    @State private var showSplashView = false
    
    
    var body: some View {
        ZStack{
            
            // background Image
            Image("background_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
            
            // dark overlay in screen
            Color.appBlack.opacity(0.2)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer()
                
               //logo and app section
                VStack(spacing: 10) {
                    //logo
                    Image("Chef Hat")
                        .foregroundColor(Color.appWhite)
                        .scaleEffect(isAnimating ? 1.0 : 0.8)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    // title
                    Text("Ezy Cook")
                        .font(.sfProRoundedBold(size: 42))
                        .foregroundColor(Color.appWhite)
                        .shadow(color: Color.appBlack.opacity(0.5), radius: 2, x: 0, y: 2)
                        .scaleEffect(isAnimating ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                }
                .padding(.top, 20)
                
                Spacer()
                
               //button
                LiquidGlassButton(
                    title: "Explore Now",
                    width: 227,
                    height: 44,
                    cornerRadius: 12,
                    fontSize: 17,
                    fontWeight: .medium
                ) {
                    // button action
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showSplashView = true
                    }
                }
                .padding(.bottom, 120)
                .scaleEffect(isAnimating ? 1.02 : 1.05)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
            }
        
        }
        .onAppear {
            isAnimating = true
            
            // animating auto transition after 10 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showSplashView = true
                }
            }
        }
        .fullScreenCover(isPresented: $showSplashView) {
            // navigating next screen
            ContentView()
        }
    }
}

#Preview {
    SplashScreenView()
}

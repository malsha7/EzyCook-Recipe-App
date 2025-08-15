//
//  LiquidGlassButton.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-14.
//

//reuse the liquid glass button

import SwiftUI

struct LiquidGlassButton: View {
    
    //propoerties - parameters
    let title: String
    let icon: String?
    let action: () -> Void
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let fontSize: CGFloat
    let fontWeight: Font.Weight
    
    //initializing
    
    init(
        title: String,
        icon: String? = nil,
        width: CGFloat = 227,
        height: CGFloat = 44,
        cornerRadius: CGFloat = 22, 
        fontSize: CGFloat = 17,
        fontWeight: Font.Weight = .medium,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
        self.fontSize = fontSize
        self.fontWeight = fontWeight
        self.action = action
    }
    
    //animation effet to hover and press
    
    @State private var isPressed = false
    @State private var shimmerOffset: CGFloat = -100
    
    
    var body: some View {
        
        Button(action: {
            // Haptic feedback for better UX
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // execute the  button action
            action()
        }) {
            HStack(spacing: 16) {
                // button text with shadow
                Text(title)
                    .font(.sfProMedium(size: fontSize))
                    .foregroundColor(Color.appWhite)
                    .shadow(color: Color.appBlack.opacity(0.3), radius: 1, x: 0, y: 1)
                
                    .padding(20)
                // if have icon in button
                    if let iconName = icon {
                    Image(systemName: iconName)
                    .font(.system(size: fontSize, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.3), radius: 1, x: 0, y: 1)
                                }
                
            }
            .frame(width: width, height: height)
            .background(
                // liquid glass effect in background
                liquidGlassBackground
            )
            .overlay(
                // enhanced the border with gradient
                enhancedBorder
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: Color.appBlack.opacity(0.1), radius: 10, x: 0, y: 5)
            .shadow(color: Color.appWhite.opacity(0.1), radius: 3, x: 0, y: -1)
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            isPressed = pressing
        } perform: {
            // long press action
        }
        .onAppear {
            // start the  shimmer animation
            startShimmerAnimation()
        }
    }
    
    // liquid glass background
    private var liquidGlassBackground: some View {
        ZStack {
            // basic frosted glass layer
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .opacity(0.3)
            
            // primary glass overlay
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color.white.opacity(0.10))
                .blur(radius: 0.5)
            
            // liquid flowing gradient for depth
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.white.opacity(0.08), location: 0.0),
                            .init(color: Color.white.opacity(0.04), location: 0.3),
                            .init(color: Color.clear, location: 0.6),
                            .init(color: Color.white.opacity(0.06), location: 1.0) // Reduced from 0.12
                        ]),
                        center: UnitPoint(x: 0.3, y: 0.2),
                        startRadius: 10,
                        endRadius: 90
                    )
                )
            
            // liquid surface reflection
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.15), //
                            Color.white.opacity(0.06), //
                            Color.clear,
                            Color.clear,
                            Color.white.opacity(0.05)  //
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .mask(
                    Rectangle()
                        .frame(height: height * 0.5)
                        .offset(y: -height * 0.25)
                )
            
            // dynamic shimmer effect
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.white.opacity(0.15), //
                            Color.white.opacity(0.25), //
                            Color.white.opacity(0.15), //
                            Color.clear
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 60)
                .offset(x: shimmerOffset)
                .blur(radius: 1)
                .opacity(0.4)
        }
    }
    
    // enhanced border
    private var enhancedBorder: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.appWhite.opacity(0.6),
                        Color.appWhite.opacity(0.2),
                        Color.appWhite.opacity(0.4),
                        Color.appWhite.opacity(0.15)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1.0
            )
    }
    
    //shimmer animation for button
    private func startShimmerAnimation() {
        withAnimation(
            Animation.linear(duration: 2.5)
                .repeatForever(autoreverses: false)
                .delay(1.0)
        ) {
            shimmerOffset = width + 100
            
            
        }
        
        
        
    }
    
}
    
#Preview {
    ZStack {
        // dark background to show the glass effect
        Color.appBlack
            .ignoresSafeArea()
        
        VStack(spacing: 30) {
            // Default button
            LiquidGlassButton(title: "Explore Now",
                              icon: "chevron.right",
                              width: 227,
                              height: 44,
                              cornerRadius: 12, // More rounded to match Figma design
                              fontSize: 17,
                              fontWeight: .medium) {
                print("Explore button tapped!")
            }
            
            // Button without icon
            LiquidGlassButton(title: "Sign In",
                              width: 227,
                              height: 44,
                              cornerRadius: 12,
                              fontSize: 17,
                              fontWeight: .medium) {
                print("Sign In button tapped!")
            }
            
            
        }
            
    }
}



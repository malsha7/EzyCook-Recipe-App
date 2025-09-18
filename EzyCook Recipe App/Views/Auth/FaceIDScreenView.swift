//
//  FaceIDScreenView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI
import LocalAuthentication
import Security


struct FaceIDScreenView: View {
    
    @State private var isAuthenticating = false
    @State private var authenticationError: String?
    @State private var showingError = false
    @State private var animationScale: CGFloat = 1.0
    @State private var navigateToHome = false
    @State private var showSuccessAlert = false
    @State private var scanningAnimation = false
    @State private var selectedTab: Int = 0
    
    @EnvironmentObject var userVM: UserViewModel
    
    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Text("Face ID Authentication")
                        .font(.sfProRoundedMedium(size: 32))
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.center)
                        .padding(.top, 60)
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appBlue.opacity(0.3), lineWidth: 1)
                            .frame(width: 180, height: 180)
                        
                        Image(systemName: "faceid")
                            .font(.system(size: 80))
                            .foregroundColor(Color.appBlue)
                            .scaleEffect(animationScale)
                            .animation(
                                Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true),
                                value: animationScale
                            )
                        
                        if scanningAnimation {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.clear,
                                            Color.appBlue.opacity(0.3),
                                            Color.appBlue,
                                            Color.appBlue.opacity(0.3),
                                            Color.clear
                                        ]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .frame(width: 160, height: 2)
                                .cornerRadius(12)
                                .modifier(ScanningLineAnimation(isScanning: scanningAnimation))
                        }
                    }
                    
                    Text(isSimulator ? "Tap to simulate Face ID" : "Position your face within the frame")
                        .font(.sfProRoundedRegular(size: 16))
                        .foregroundColor(.appBlue.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    VStack(spacing: 16) {
                        if isAuthenticating {
                            LiquidGlassButton(
                                title: "Authenticating...",
                                icon: nil,
                                width: 280,
                                height: 56,
                                cornerRadius: 12,
                                fontSize: 18,
                                fontWeight: .semibold
                            ) {}
                            .overlay(
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .appWhite))
                                        .scaleEffect(0.8)
                                    Spacer()
                                }
                                .padding(.leading, 20)
                            )
                        } else {
                            LiquidGlassButton(
                                title: isSimulator ? "Simulate Face ID" : "Authenticate with Face ID",
                                icon: "faceid",
                                width: 280,
                                height: 56,
                                cornerRadius: 12,
                                fontSize: 18,
                                fontWeight: .semibold
                            ) {
                                authenticateUser()
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $navigateToHome) {
                HomeView(selectedTab: $selectedTab)
                    .environmentObject(userVM)
            }
        }
        .onAppear {
            animationScale = 1.1
            if !isSimulator {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    authenticateUser()
                }
            }
        }
        .alert("Authentication Error", isPresented: $showingError) {
            Button("Try Again") { authenticateUser() }
            Button("Cancel", role: .cancel) { scanningAnimation = false }
        } message: {
            Text(authenticationError ?? "Unknown error occurred")
        }
        .alert("Authentication Successful", isPresented: $showSuccessAlert) {
            Button("Continue") { navigateToHome = true }
        } message: {
            Text("Face ID authentication completed successfully!")
        }
    }
    
    
    private func authenticateUser() {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        scanningAnimation = true
        authenticationError = nil
        
        if isSimulator {
            simulateAuthentication()
        } else {
            performFaceIDAuthentication()
        }
    }
    
    private func simulateAuthentication() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isAuthenticating = false
            scanningAnimation = false
            handleSuccessfulAuth()
        }
    }
    
    private func performFaceIDAuthentication() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate with Face ID to access your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    isAuthenticating = false
                    scanningAnimation = false
                    
                    if success {
                        handleSuccessfulAuth()
                    } else {
                        self.authenticationError = (authError as? LAError)?.localizedDescription ?? "Face ID failed"
                        self.showingError = true
                    }
                }
            }
        } else {
            isAuthenticating = false
            authenticationError = "Face ID not available on this device"
            showingError = true
        }
    }
    
   
    private func handleSuccessfulAuth() {
       
        guard let tokenData = KeychainHelper.shared.load(key: "auth_token"),
              let token = String(data: tokenData, encoding: .utf8) else {
            authenticationError = "No previous login found. Please login with username/password first."
            showingError = true
            return
        }
        
        print("Face ID authenticated. Using token: \(token)")
        
       
        userVM.authToken = token
        
        
        userVM.getProfile()
        
        
        showSuccessAlert = true
    }
}


struct ScanningLineAnimation: ViewModifier {
    let isScanning: Bool
    @State private var yOffset: CGFloat = -80
    
    func body(content: Content) -> some View {
        content
            .offset(y: yOffset)
            .onAppear { if isScanning { startScanning() } }
            .onChange(of: isScanning) { newValue in
                if newValue { startScanning() } else { resetPosition() }
            }
    }
    
    private func startScanning() {
        yOffset = -80
        withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: true)) {
            yOffset = 80
        }
    }
    
    private func resetPosition() {
        withAnimation(.easeOut(duration: 0.3)) { yOffset = -80 }
    }
}

#Preview {
    FaceIDScreenView()
}

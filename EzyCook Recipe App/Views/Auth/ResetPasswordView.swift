//
//  ResetPasswordView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var navigateToSignIn = false
    @State private var alertMessage = ""
    @State private var validationErrors: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
       
        NavigationView {
            ZStack {
                // background image
                Image("Signin_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()
                
                // dark overlay
                Color.appBlack.opacity(0.2)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 110)
                        
                        VStack(spacing: 4) {
                            Text("Create Password")
                                .font(.sfProRoundedMedium(size: 32))
                                .foregroundColor(.appWhite)
                                .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)
                            
                            Text("Enter Your New Password. If you forget it.")
                                .font(.sfProRegular(size: 16))
                                .foregroundColor(.appWhite.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                        }
                        .padding(.bottom, 40)
                        .scaleEffect(isAnimating ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 8) {
                                AuthTextField.newPassword(text: $newPassword)
                                
                                // new password error message
                                if let newPasswordError = validationErrors["newPassword"] {
                                    HStack {
                                        Text(newPasswordError)
                                            .font(.sfProRegular(size: 12))
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .frame(maxWidth: 320)
                                }
                            }
                            
                            VStack(spacing: 8) {
                                AuthTextField.confirmPassword(text: $confirmPassword)
                                
                                // confirm password error message
                                if let confirmPasswordError = validationErrors["confirmPassword"] {
                                    HStack {
                                        Text(confirmPasswordError)
                                            .font(.sfProRegular(size: 12))
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .frame(maxWidth: 320)
                                }
                            }
                            
                            // button
                            LiquidGlassButton(
                                title: "Confirm",
                                width: 227,
                                height: 44,
                                cornerRadius: 12,
                                fontSize: 17,
                                fontWeight: .medium
                            ) {
                                handleConfirm()
                            }
                            .scaleEffect(isAnimating ? 1.02 : 1.05)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                            .padding(.top, 30)
                            

                        }
                        .padding(.horizontal, 40)
                        
                        Spacer(minLength: 100)
                    }
                }
                
                NavigationLink(destination: SignInView().navigationBarHidden(true), isActive: $navigateToSignIn) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            isAnimating = true
        }
        .alert("Reset Password", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                
                navigateToSignIn = true
            }
        } message: {
            Text(alertMessage)
        }
        
    }
    
    // functions
    private func handleConfirm() {
        // clear previous errors
        validationErrors = [:]
        
        let errors = ValidationHelper.validateResetPasswordFields(
            newPassword: newPassword,
            confirmPassword: confirmPassword
        )
        
        if !errors.isEmpty {
            validationErrors = errors
            return
        }
        
        // if validation passes, proceed with password reset
        alertMessage = "Password has been reset successfully! Please sign in with your new password."
        showAlert = true
    }

}

#Preview {
    ResetPasswordView()
}

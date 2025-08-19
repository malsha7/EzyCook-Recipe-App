//
//  ForgotPasswordView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email = ""
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var validationErrors: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
                        Text("Forgot Password")
                            .font(.sfProRoundedMedium(size: 32))
                            .foregroundColor(.appWhite)
                            .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)
                        
                        Text("Enter Your Email Address.We will send an OTP code for verification in the next step")
                            .font(.sfProRegular(size: 16))
                            .foregroundColor(.appWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }
                    .padding(.bottom, 40)
                    .scaleEffect(isAnimating ? 1.02 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                    VStack(spacing: 20) {
                        
                        VStack(spacing: 8) {
                            AuthTextField.email(text: $email)
                            
                            // email error message
                            if let emailError = validationErrors["email"] {
                                HStack {
                                    Text(emailError)
                                        .font(.sfProRegular(size: 12))
                                        .foregroundColor(.red)
                                    Spacer()
                                }
                                .frame(maxWidth: 320)
                            }
                        }
                        
                        // button
                        LiquidGlassButton(
                            title: "Continue",
                            width: 227,
                            height: 44,
                            cornerRadius: 12,
                            fontSize: 17,
                            fontWeight: .medium
                        ) {
                            handleContinue()
                        }
                        .scaleEffect(isAnimating ? 1.02 : 1.05)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                        .padding(.top, 30)
                        
                        HStack(spacing: 4) {
                            Text("Remember your password?")
                                .foregroundColor(.appWhite.opacity(0.8))
                                .font(.sfProMedium(size: 16))
                            
                            Button("Sign In") {
                                dismiss()
                            }
                            .foregroundColor(.appWhite)
                            .font(.sfProMedium(size: 16))
                        }
                        .padding(.top, 20)
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .alert("Forgot Password", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // functions
    private func handleContinue() {
        // clear previous errors
        validationErrors = [:]
        
       
        let errors = ValidationHelper.validateForgotPasswordFields(email: email)
        
        if !errors.isEmpty {
            validationErrors = errors
            return
        }
        
        // if validation passes, proceed with sending reset email
        alertMessage = "Password reset OTP passcode have been sent to your email address."
        showAlert = true
    }
}

#Preview {
    ForgotPasswordView()
}

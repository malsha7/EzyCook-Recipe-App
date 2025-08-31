//
//  SignUpView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI

struct SignUpView: View {
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var showHome = false
    @State private var alertMessage = ""
    @State private var showSignIn = false
    @State private var showPrivacyPolicy = false
    @State private var validationErrors: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var userVM: UserViewModel
    
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
                    Spacer(minLength: 80)
                    
                    VStack(spacing: 4) {
                        Text("Create Account")
                            .font(.sfProRoundedMedium(size: 32))
                            .foregroundColor(.appWhite)
                            .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)
                            .fullScreenCover(isPresented: $showPrivacyPolicy) {
                                PrivacyPolicyView()
                            }
                            .padding(.bottom, 50)
                            .scaleEffect(isAnimating ? 1.02 : 1.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        VStack(spacing: 20) {
                            
                            VStack(spacing: 8) {
                                AuthTextField.username(text: $username)
                                
                                // username error message
                                if let usernameError = validationErrors["username"] {
                                    HStack {
                                        Text(usernameError)
                                            .font(.sfProRegular(size: 12))
                                            .foregroundColor(.red)
                                        Spacer()
                                    }
                                    .frame(maxWidth: 320)
                                }
                            }
                            
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
                            
                            VStack(spacing: 8) {
                                AuthTextField.password(text: $password)
                                
                                // password error message
                                if let passwordError = validationErrors["password"] {
                                    HStack {
                                        Text(passwordError)
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
                            
                            //  button
                            LiquidGlassButton(
                                title: "Sign Up",
                                width: 227,
                                height: 44,
                                cornerRadius: 12,
                                fontSize: 17,
                                fontWeight: .medium
                            ) {
                                handleSignUp()
                            }
                            .scaleEffect(isAnimating ? 1.02 : 1.05)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                            .padding(.top, 30)
                            
                            Button(action: {
                                showPrivacyPolicy = true
                            }) {
                                Text("By creating an account, you agree to our Terms of Service and Privacy Policy")
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .font(.sfProRegular(size: 13))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                            }
                            .padding(.top, 10)
                            
                            HStack(spacing: 4) {
                                Text("Already have an account?")
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
                        
                        Spacer(minLength: 60)
                    }
                }
            }
            .onAppear {
                isAnimating = true
            }
            .alert("Sign Up", isPresented: $showAlert) {
                Button("OK", role: .cancel) {
                    showHome = true
                }
            } message: {
                Text(alertMessage)
            }
            .fullScreenCover(isPresented: $showHome) {
                ProfileView()
                    .environmentObject(userVM) // pass if needed
            }
        }
    }
    
    // functions
    private func handleSignUp() {
        // clear previous errors
        validationErrors = [:]
        
        let errors = ValidationHelper.validateSignUpFields(
            username: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword
        )
        
        if !errors.isEmpty {
            validationErrors = errors
            return
        }
        
        //connect with usermodel via backend
        userVM.signup(username: username, email: email, password: password) { success in
            if success {
                print("Signup successful")
                alertMessage = "Account created successfully!"
                showAlert = true
               
            } else {
                print("Signup failed")
                alertMessage = "Error: Signup failed"
                showAlert = true
            }
        }
    }
    
}

#Preview {
    SignUpView()
}

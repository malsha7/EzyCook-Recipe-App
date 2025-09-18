//
//  SignInView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI

struct SignInView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var showHome = false
    @State private var alertMessage = ""
    @State private var showFaceID = false
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    @State private var validationErrors: [String: String] = [:]
    @State private var selectedTab: Int = 0
    
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var vm : RecipeViewModel
    
    var body: some View {
        ZStack {
        //background image
            Image("Signin_image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .ignoresSafeArea()
            
            // dark overly
            Color.appBlack.opacity(0.2)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 80)
                    
                    VStack(spacing: 4) {
                        Text("Welcome Back")
                            .font(.sfProRoundedMedium(size: 32))
                            .foregroundColor(.appWhite)
                            .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)
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

                        
                        HStack {
                            Button("Forgot Password ?") {
                                handleForgotPassword()
                            }
                            .foregroundColor(.appWhite)
                            .font(.sfProMedium(size: 16))
                            Spacer()
                        }
                        .frame(maxWidth: 320)
                        .padding(.top, 8)
                        
                       //sign in
                        LiquidGlassButton(
                            title: "Sign In",
                            width: 227,
                            height: 44,
                            cornerRadius: 12,
                            fontSize: 17,
                            fontWeight: .medium
                        ) {
                            handleSignIn()
                        }
                        .scaleEffect(isAnimating ? 1.02 : 1.05)
                        .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isAnimating)
                        .padding(.top, 30)
                        
                       
                        HStack(spacing: 4) {
                            Text("Don't have Already account ?")
                                .foregroundColor(.appWhite.opacity(0.8))
                                .font(.sfProMedium(size: 16))
                            
                            Button("Sign Up") {
                                showSignUp = true
                            }
                            .foregroundColor(.appWhite)
                            .font(.sfProMedium(size: 16))
                        }
                        .padding(.top, 20)
                         // Or divider
                        HStack(spacing: 12) {
                            Rectangle()
                                .fill(Color.appWhite)
                                .frame(height: 0.5)
                            
                            Text("Or")
                                .foregroundColor(.appWhite)
                                .font(.sfProRegular(size: 17))
                            
                            Rectangle()
                                .fill(Color.appWhite)
                                .frame(height: 0.5)
                        }
                        .padding(.vertical, 20)
                        
                        // face id button
                        Button(action: {
                            showFaceID = true
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "faceid")
                                    .font(.sfProSemibold(size: 20))
                                
                                Text("Use Face ID")
                                    .font(.sfProSemibold(size: 17))
                            }
                            .foregroundColor(.appWhite)
                            .shadow(color: .appBlack.opacity(0.2), radius: 1, x: 0, y: 1)
                            .frame(width: 340, height: 44)
                            .background(
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.regularMaterial)
                                        .environment(\.colorScheme, .light)
                                        .opacity(0.25)
                                    
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appWhite.opacity(0.04))
                                        .blur(radius: 0.5)
                                }
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.appWhite.opacity(0.15), lineWidth: 0.5)
                            )
                            .clipped()
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer(minLength: 60)
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
        .alert("Sign In", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                
                showHome = true
            }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showHome) {
           //MyRecipesView()
            MainView()
           // HomeView(selectedTab: $selectedTab)
               .environmentObject(userVM)
        }
        .fullScreenCover(isPresented: $showFaceID) {
            FaceIDScreenView()
        }
        .fullScreenCover(isPresented: $showSignUp) {
            SignUpView()
        }
        .fullScreenCover(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }
    
    // functions
    private func handleSignIn() {
        // clear previous errors
        validationErrors = [:]
        
        // validate signin fields
        let errors = ValidationHelper.validateSignInFields(username: username, password: password)
        
        if !errors.isEmpty {
            validationErrors = errors
            return
        }
        
        //connect with usermodel through backend
        
        userVM.login(username: username, password: password) { success in
            if success {
                print("Signin successful")
                alertMessage = "Signin successfully!"
                showAlert = true
               
            } else {
                print("Signin failed")
                alertMessage = "Error: Signin failed"
                showAlert = true
            }
        }
       
    }
    
    private func handleForgotPassword() {
        showForgotPassword = true
    }
}

#Preview {
    SignInView()
}

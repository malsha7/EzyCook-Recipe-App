//
//  OTPView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI

struct OTPView: View {
    
    @State private var otpCode = ["", "", "", ""]
    @State private var isAnimating = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showResetPassword = false
    @State private var validationErrors: [String: String] = [:]
    @FocusState private var focusedField: Int?
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
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .font(.sfProMedium(size: 16))
                                .foregroundColor(.appBlue)
                            
                            Text("Back")
                                .font(.sfProMedium(size: 16))
                                .foregroundColor(.appBlue)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 65)
                .padding(.top, 40)
                
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer(minLength: 50)
                        
                        VStack(spacing: 4) {
                            Text("OTP Verification")
                                .font(.sfProRoundedMedium(size: 32))
                                .foregroundColor(.appWhite)
                                .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)
                            
                            VStack(spacing: 4) {
                                Text("We have sent OTP code verification to your")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                
                                Text("email address. Check your email and enter")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                
                                Text("the code below")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                        }
                        .padding(.bottom, 40)
                        .scaleEffect(isAnimating ? 1.02 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAnimating)
                        
                        VStack(spacing: 40) {
                            // otp inputfeild
                            HStack(spacing: 40) {
                                ForEach(0..<4, id: \.self) { index in
                                    OTPInputField(
                                        text: $otpCode[index],
                                        isActive: focusedField == index
                                    )
                                    .focused($focusedField, equals: index)
                                    .onChange(of: otpCode[index]) { oldValue, newValue in
                                        handleOTPInput(index: index, oldValue: oldValue, newValue: newValue)
                                    }
                                }
                            }
                            .padding(.horizontal, 40)
                            
                            // otp error message
                            if let otpError = validationErrors["otp"] {
                                Text(otpError)
                                    .font(.sfProRegular(size: 12))
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 40)
                            }
                            
                            // resend otp
                            HStack(spacing: 4) {
                                Text("Didn't receive email ?")
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .font(.sfProRegular(size: 16))
                                
                                Button("Resend it") {
                                    handleResendOTP()
                                }
                                .foregroundColor(.appWhite)
                                .font(.sfProMedium(size: 16))
                            }
                            .padding(.top, 10)
                            
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
                        }
                        
                        Spacer(minLength: 100)
                    }
                }
            }
        }
        .onAppear {
            isAnimating = true
            focusedField = 0
        }
        .alert("OTP Verification", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $showResetPassword) {
            ResetPasswordView()
        }
        
    }
    
    // functions
    private func handleOTPInput(index: Int, oldValue: String, newValue: String) {
        // allow single digit
        if newValue.count > 1 {
            otpCode[index] = String(newValue.suffix(1))
        }
        
        // move to next field if digit is entered
        if !newValue.isEmpty && index < 3 {
            focusedField = index + 1
        }
        
        // move to previous field if digit is deleted
        if newValue.isEmpty && index > 0 {
            focusedField = index - 1
        }
    }
    
    private func handleResendOTP() {
        alertMessage = "OTP code has been resent to your email address."
        showAlert = true
        
        // clear current otp
        otpCode = ["", "", "", ""]
        focusedField = 0
    }
    
    private func handleContinue() {
        // clear previous errors
        validationErrors = [:]
        
        // validate otp
        let fullOTP = otpCode.joined()
        
        if fullOTP.isEmpty || fullOTP.count < 4 {
            validationErrors["otp"] = "Please enter the complete OTP code"
            return
        }
        
        // checking if all fields contain digits
        for code in otpCode {
            if code.isEmpty || !code.allSatisfy({ $0.isNumber }) {
                validationErrors["otp"] = "Please enter a valid OTP code"
                return
            }
        }
        
        // if validation passes, navigate to reset password
        showResetPassword = true
    }
}

// otp input field
struct OTPInputField: View {
    @Binding var text: String
    let isActive: Bool
    
    var body: some View {
        TextField("", text: $text)
            .frame(width: 50, height: 50)
            .multilineTextAlignment(.center)
            .font(.sfProRoundedMedium(size: 24))
            .foregroundColor(.appWhite)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
                    .environment(\.colorScheme, .light)
                    .opacity(0.3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        isActive ? Color.appWhite.opacity(0.6) : Color.appWhite.opacity(0.3),
                        lineWidth: isActive ? 2 : 1
                    )
            )
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .onChange(of: text) { oldValue, newValue in
                // limit single digit
                if newValue.count > 1 {
                    text = String(newValue.suffix(1))
                }
                //  allow only numbers
                text = text.filter { $0.isNumber }
            }
    }
}


#Preview {
    OTPView()
}

//
//  PrivacyPolicyView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-15.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // top bar navigation row
            HStack {
                Button(action: {
                    // back to settings screen
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.appBlue)
                        Text("Back")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
                
                Text("Privacy Policy")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // space to balance the layout
                Spacer()
                    .frame(width: 44)
            }
            
            // divider line
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // last updated info title
            HStack {
                Text("Last updated: August 2025")
                    .font(.sfProMedium(size: 16))
                    .foregroundColor(.appWhite)
                    .italic()
                Spacer()
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    
                    PrivacySection(
                        number: "1.",
                        title: "Your Privacy Matters",
                        content: "We collect only what's necessary: your email, recipes you save, and app usage info to give you a personalized cooking experience."
                    )
                    
                   
                    PrivacySection(
                        number: "2.",
                        title: "What We Collect",
                        content: "Email address (to sign up)\nRecipes saved, cooking tools chosen"
                    )
                    
                   
                    PrivacySection(
                        number: "3.",
                        title: "Why We Collect It",
                        content: "Save your preferences and progress\nRecommend recipes based on your tools\nImprove app performance and features"
                    )
                    
                   
                    PrivacySection(
                        number: "4.",
                        title: "Your Control",
                        content: "You can update or delete your account anytime. We don't sell your data. You may opt out of notifications and request deletion via Settings."
                    )
                    
                   
                    PrivacySection(
                        number: "5.",
                        title: "Face ID & Security",
                        content: "Face ID is optional and secure. We follow Apple's biometric standards and never store your biometric data."
                    )
                    
                    // contact us
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top, spacing: 8) {
                            Text("6.")
                                .font(.sfProBold(size: 16))
                                .foregroundColor(.appBlue)
                                .frame(width: 20, alignment: .leading)
                            
                            Text("Contact Us")
                                .font(.sfProBold(size: 16))
                                .foregroundColor(.appWhite)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("For any questions or requests")
                                .font(.sfProMedium(size: 14))
                                .foregroundColor(.appWhite.opacity(0.8))
                                .padding(.leading, 28)
                            
                            Text("Support@ezycookapp.com")
                                .font(.sfProMedium(size: 14))
                                .foregroundColor(.appBlue)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(Color.appBlue.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.appBlue.opacity(0.3), lineWidth: 1)
                                )
                                .padding(.leading, 28)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(Color.appWhite.opacity(0.05))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appWhite.opacity(0.1), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 4)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
    }
}

#Preview {
    PrivacyPolicyView()
}

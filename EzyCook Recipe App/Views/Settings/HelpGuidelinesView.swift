//
//  HelpGuidelinesView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-15.
//

import SwiftUI

struct HelpGuidelinesView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20){
            
            // top navigation row
            HStack {
                Button(action: {
                    // back to the settings screen
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
                
                Text("Help & Guidelines")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                //  space to balance the layout
                Spacer()
                    .frame(width: 44)
            }
            
            // divider line
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            ScrollView{
                VStack(alignment: .leading, spacing: 24) {
                    // helps & tips Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .foregroundColor(.appBlue)
                                .font(.system(size: 20))
                            Text("Helps & Tips")
                                .font(.sfProBold(size: 18))
                                .foregroundColor(.appWhite)
                        }
                        
                        VStack(alignment: .leading, spacing: 16) {
                            HelpItem(
                                number: "1.",
                                title: "Getting Started",
                                description: "Search or browse recipes by your taste, ingredients, or cooking time.\n\nTap \"Start Choose\" to begin a daily meal plan suggestion."
                            )
                            
                            HelpItem(
                                number: "2.",
                                title: "Choosing Tools",
                                description: "You can select your available cooking tools (e.g., Microwave, Rice Cooker) during setup or in the \"Recipe Plan\" screen.\n\nRecipes are filtered to only show compatible steps based on your selected tools."
                            )
                            
                            HelpItem(
                                number: "3.",
                                title: "Ingredients & Time",
                                description: "You can input available ingredients (e.g., eggs, noodles) and set your meal time (e.g., lunch or dinner).\n\nEzy Cook will generate recipe recommendations that match both the time and what you have at home."
                            )
                            
                            HelpItem(
                                number: "4.",
                                title: "Biometric Login",
                                description: "After your first login, you can enable Face ID for quick access.\n\nIf Face ID fails, fallback to password is always available."
                            )
                            
                            HelpItem(
                                number: "5.",
                                title: "Account & Preferences",
                                description: "From Settings, update your email, password, or turn off notifications.\n\nYou can clear saved recipes or log out at any time."
                            )
                        }
                        
                        // support section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Need Help?")
                                .font(.sfProBold(size: 14))
                                .foregroundColor(.appWhite)
                            
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
                        }
                    }
                    .padding(.horizontal, 4)
                }
             }
                
                Spacer()
        }
            .padding()
            .background(Color.appBlack.ignoresSafeArea())
            
        }
    }
    


        
    




#Preview {
    HelpGuidelinesView()
}

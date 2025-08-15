//
//  PrivacySection.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-15.
//

import SwiftUI

struct PrivacySection: View {
    let number: String
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Text(number)
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appBlue)
                    .frame(width: 20, alignment: .leading)
                
                Text(title)
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
            }
            
            Text(content)
                .font(.sfProRegular(size: 14))
                .foregroundColor(.appWhite.opacity(0.8))
                .lineSpacing(2)
                .padding(.leading, 28)
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
}

#Preview {
    
    ZStack{
        //background color
            Color.appBlack.ignoresSafeArea()
        PrivacySection(
            number: "1.",
            title: "Your Privacy Matters",
            content: "We collect only what's necessary: your email, recipes you save, and app usage info to give you a personalized cooking experience."
        )
    }
}

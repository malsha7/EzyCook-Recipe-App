//
//  BottomNavBar.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-17.
//

import SwiftUI

struct BottomNavBar: View {
    
    @Binding var selectedTab: Int
    
    private let width: CGFloat = 340
    private let height: CGFloat = 57
    private let iconSize: CGFloat = 24
    
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            
            navButton(tab: 0, imageName: "Home")
            Spacer()
            
            navButton(tab: 1, imageName: "Select")
            Spacer()
            
            navButton(tab: 2, imageName: "myrecipe")
            Spacer()
            
            navButton(tab: 3, imageName: "Heart")
            Spacer()
            
            navButton(tab: 4, imageName: "Settings")
            
            Spacer()
        }
        .frame(width: width, height: height)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appWhite.opacity(0.3))
                .blur(radius: 1)
                .shadow(color: Color.appBlack.opacity(0.1), radius: 10, x: 0, y: 5)
                .shadow(color: Color.appWhite.opacity(0.1), radius: 3, x: 0, y: -1)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appWhite.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private func navButton(tab: Int, imageName: String) -> some View {
        Button(action: { selectedTab = tab }) {
            Image(selectedTab == tab ? "\(imageName)_fill" : imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: iconSize, height: iconSize)
                .foregroundColor(.appWhite)
        }
    }
    
}




//#Preview {
//    BottomNavBar()
//}

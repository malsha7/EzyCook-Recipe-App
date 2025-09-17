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
            
            navButton(tab: 0, systemIcon: "house")
            Spacer()
            
            navButton(tab: 1, systemIcon: "square.grid.2x2")
            Spacer()
            
            navButton(tab: 2, systemIcon: "person.crop.square")
            Spacer()
            
            navButton(tab: 3, systemIcon: "heart")
            Spacer()
            
            navButton(tab: 4, systemIcon: "gearshape")
            
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
    private func navButton(tab: Int, systemIcon: String) -> some View {
        Button(action: { selectedTab = tab }) {
            Image(systemName: selectedTab == tab ? "\(systemIcon).fill" : systemIcon)
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

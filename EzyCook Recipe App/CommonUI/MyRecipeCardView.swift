//
//  MyRecipeCardView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-14.
//

import SwiftUI

struct MyRecipeCardView: View {
    
    let recipe: Recipe
    let onTap: () -> Void
    
    var body: some View {
        
        Button(action: {
            onTap()
        }) {
            ZStack {
                HStack(spacing: 14) {
                    
                    
                    AsyncImage(url: recipe.displayImageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 86, height: 86)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure(_):
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.appWhite.opacity(0.1))
                                .overlay(
                                    Image("image_1")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .padding(20)
                                )
                        @unknown default:
                            Color.gray
                        }
                    }
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                   
                    Text(recipe.title)
                        .font(.sfProMedium(size: 16))
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 86)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                
               
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            onTap()
                        }) {
                            Text("View")
                                .font(.sfProMedium(size: 14))
                                .foregroundColor(.appWhite)
                                .frame(width: 90, height: 30)
                                .background(Color.appWhite.opacity(0.3))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.bottom, 10)
                .padding(.trailing, 10)
            }
            .padding(10)
            .frame(width: 332, height: 118)
            .background(Color.appWhite.opacity(0.3))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        
       
    }
}

//#Preview {
//    MyRecipeCardView()
//}

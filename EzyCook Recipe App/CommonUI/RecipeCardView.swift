//
//  RecipeCardView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import SwiftUI

struct RecipeCardView: View {
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
                                    Image(systemName: "photo")
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
                    
                  
                    VStack(alignment: .leading, spacing: 10) {
                       
                        HStack {
                            Text(recipe.title)
                                .font(.sfProMedium(size: 16))
                                .foregroundColor(.appWhite)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            // fav icon
//                             Image(systemName: "heart.fill")
//                                 .foregroundColor(.white)
//                                 .font(.system(size: 20))
                        }
                        
                        HStack(spacing: 10) {
                            HStack(spacing: 4) {
                                Text("Time:")
                                    .font(.sfProRegular(size: 12))
                                    .foregroundColor(.appWhite.opacity(0.7))
                                Text(recipe.mealTime ?? "N/A")
                                    .font(.sfProRegular(size: 12))
                                    .foregroundColor(.appWhite)
                            }
                            
                            
                        }
                        
                        Spacer()
                    }
                    .frame(height: 86)
                    
                    Spacer()
                }
                
              
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
//    RecipeCardView()
//}

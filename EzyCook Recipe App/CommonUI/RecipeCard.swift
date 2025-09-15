//
//  RecipeCard.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-15.
//

import SwiftUI

struct RecipeCard: View {
    
    let recipe: Recipe
    @State private var isAnimating = false
    @State private var isLiked = false
    
    
    var body: some View {
        
        Button(action: {
           
            print("Recipe card tapped: \(recipe.title)")
        }) {
            VStack(spacing: 8) {
              
                ZStack(alignment: .topTrailing) {
                   
                    if let imageUrl = recipe.displayImageURL {
                        AsyncImage(url: imageUrl) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 180, height: 150)
                                .clipped()
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 180, height: 150)
                                .overlay(ProgressView())
                        }
                    } else {
                       
                        Image("image_1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 180, height: 150)
                            .clipped()
                    }
                    
                   
                    Button(action: { isLiked.toggle() }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(.appWhite)
                            .font(.system(size: 20))
                            .background(
                                Circle()
                                    .fill(Color.appBlack.opacity(0.3))
                                    .frame(width: 32, height: 32)
                            )
                    }
                    .padding(.top, 12)
                    .padding(.trailing, 12)
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                
               
                VStack(alignment: .center, spacing: 4) {
                  
                    Text(recipe.title)
                        .font(.sfProRoundedMedium(size: 14))
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                    
                  
                    if let servings = recipe.servings {
                        Text("Servings: \(servings)")
                            .font(.sfProRoundedRegular(size: 12))
                            .foregroundColor(.appWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                    
                   
                    if let tools = recipe.tools, !tools.isEmpty {
                        Text("Tools: \(tools.prefix(2).joined(separator: ", "))")
                            .font(.sfProRoundedRegular(size: 12))
                            .foregroundColor(.appWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                    
                  
                    if let mealTime = recipe.mealTime {
                        Text(mealTime)
                            .font(.sfProRoundedRegular(size: 12))
                            .foregroundColor(.appWhite.opacity(0.8))
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(width: 180, height: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appWhite.opacity(0.3))
        )
        .onAppear {
            isAnimating = true
        }
       
    }
}

//#Preview {
//    RecipeCard()
//}

//
//  RecipeDetailsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-14.
//

import SwiftUI

struct RecipeDetailsView: View {
    
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    @State private var isFavorited = false
    @State private var isAdded = false
    
    var body: some View {
        
        ZStack {
            Color.appBlack.ignoresSafeArea()
            
            VStack(spacing: 0) {
              
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.appBlue)
                            Text("Back")
                                .foregroundColor(.appBlue)
                                .font(.sfProMedium(size: 16))
                        }
                    }
                    
                    Spacer()
                    
                    Text("Recipe Details")
                        .font(.sfProBold(size: 18))
                        .foregroundColor(.appWhite)
                    
                    Spacer()
                    
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isFavorited.toggle()
                        }
                        
                        saveToFavorites()
                    }) {
                        Image(systemName: isFavorited ? "heart.fill" : "heart")
                            .foregroundColor(isFavorited ? .appWhite : .appWhite)
                            .font(.system(size: 20))
                            .scaleEffect(isFavorited ? 1.1 : 1.0)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                .background(Color.appBlack)
                
                
                Rectangle()
                    .fill(Color.appWhite.opacity(0.25))
                    .frame(height: 1)
                
                
                ScrollView {
                    VStack(spacing: 0) {
                        
                        HStack {
                            Text(recipe.title)
                                .font(.sfProBold(size: 24))
                                .foregroundColor(.appWhite)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        
                        AsyncImage(url: recipe.displayImageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 250)
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 250)
                                    .clipped()
                            case .failure(_):
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.appWhite.opacity(0.1))
                                    .frame(height: 250)
                                    .overlay(
                                        Image("recipe image")
                                            .aspectRatio(contentMode: .fill)
                                            .frame(height: 250)
                                            .clipped()
                                            .foregroundColor(.gray)
                                    )
                            @unknown default:
                                Color.gray.frame(height: 250)
                            }
                        }
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 8) {
                               
                                Text("Cook Time : \(recipe.mealTime ?? "20min")")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite)
                                
                               
                                Text("Tools : \(recipe.tools?.joined(separator: ", ") ?? "Gas Cooker")")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite)
                                
                                
                                Text("Servings : \(recipe.servings ?? 2)")
                                    .font(.sfProMedium(size: 14))
                                    .foregroundColor(.appWhite)
                            }
                            
                            Spacer()
                            
                            
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    isAdded.toggle()
                                }
                                addRecipeToMealPlan()
                            }) {
                                HStack(spacing: 6) {
                                    Image(systemName: isAdded ? "checkmark" : "calendar.badge.plus")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.appWhite)
                                    Text(isAdded ? "Added" : "Add")
                                        .font(.sfProMedium(size: 14))
                                        .foregroundColor(.appWhite)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(isAdded ? Color.green.opacity(0.8) : Color.appWhite.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(isAdded ? Color.green : Color.appWhite.opacity(0.3), lineWidth: 1)
                                        )
                                )
                                .scaleEffect(isAdded ? 0.95 : 1.0)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Ingredients")
                                    .font(.sfProBold(size: 18))
                                    .foregroundColor(.appWhite)
                                Spacer()
                            }
                            
                            if recipe.ingredients.isEmpty {
                                Text("No ingredients listed.")
                                    .font(.sfProRegular(size: 14))
                                    .foregroundColor(.appWhite.opacity(0.8))
                            } else {
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                        HStack(alignment: .top) {
                                            if let quantity = ingredient.quantity, !quantity.isEmpty {
                                                Text("\(quantity) \(ingredient.name)")
                                                    .font(.sfProMedium(size: 14))
                                                    .foregroundColor(.appWhite)
                                            } else {
                                                Text(ingredient.name)
                                                    .font(.sfProMedium(size: 14))
                                                    .foregroundColor(.appWhite)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Cooking Instructions")
                                    .font(.sfProBold(size: 18))
                                    .foregroundColor(.appWhite)
                                Spacer()
                            }
                            
                            Text(recipe.description.isEmpty ? "No cooking instructions provided." : recipe.description)
                                .font(.sfProRegular(size: 14))
                                .foregroundColor(.appWhite.opacity(0.8))
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                playRecipeVideo()
                            }) {
                                HStack(spacing: 6) {
                                    Image("Video")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.appWhite)
                                    Text("Watch")
                                        .font(.sfProMedium(size: 14))
                                        .foregroundColor(.appWhite)
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.appWhite.opacity(0.15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.appWhite.opacity(0.4), lineWidth: 0.5)
                                        )
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        
        
    }
    
    private func saveToFavorites() {
       
        print("Recipe \(isFavorited ? "added to" : "removed from") favorites")
       
    }
    
    private func addRecipeToMealPlan() {
      
        print("Recipe \(isAdded ? "added to" : "removed from") meal plan")
       
    }
    
    private func playRecipeVideo() {
       
        print("Playing recipe video")
        
    }
    
    
    
}

//#Preview {
//    RecipeDetailsView()
//}

//
//  MyRecipeDetailsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-14.
//

import SwiftUI

struct MyRecipeDetailsView: View {
    
    let recipe: Recipe
    @Environment(\.dismiss) private var dismiss
    
    
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
                    
                    Text(recipe.title)
                        .font(.sfProBold(size: 16))
                        .foregroundColor(.appWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Spacer().frame(width: 60)
                }
                .padding()
                .background(Color.appBlack)
                
                
                Rectangle()
                    .fill(Color.appWhite.opacity(0.25))
                    .frame(height: 1)
                
               
                ScrollView {
                    VStack(spacing: 20) {
                       
                        
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
                        .frame(width: 350, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                       
                        VStack(alignment: .leading, spacing: 20) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Ingredients")
                                    .font(.sfProBold(size: 18))
                                    .foregroundColor(.appWhite)
                                
                                if recipe.ingredients.isEmpty {
                                    Text("No ingredients listed.")
                                        .font(.sfProRegular(size: 14))
                                        .foregroundColor(.appWhite.opacity(0.8))
                                } else {
                                    LazyVStack(alignment: .leading, spacing: 6) {
                                        ForEach(Array(recipe.ingredients.enumerated()), id: \.offset) { index, ingredient in
                                            HStack(alignment: .top, spacing: 8) {
                                                Text("•")
                                                    .font(.sfProMedium(size: 14))
                                                    .foregroundColor(.appWhite)
                                                
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text(ingredient.name)
                                                        .font(.sfProMedium(size: 14))
                                                        .foregroundColor(.appWhite)
                                                    
                                                    if let quantity = ingredient.quantity, !quantity.isEmpty {
                                                        Text(quantity)
                                                            .font(.sfProRegular(size: 12))
                                                            .foregroundColor(.appWhite.opacity(0.7))
                                                    }
                                                }
                                                
                                                Spacer()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Description")
                                    .font(.sfProBold(size: 18))
                                    .foregroundColor(.appWhite)
                                
                                Text(recipe.description.isEmpty ? "No description provided." : recipe.description)
                                    .font(.sfProRegular(size: 14))
                                    .foregroundColor(.appWhite.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
        }
        
    }
}

//#Preview {
//    MyRecipeDetailsView()
//}

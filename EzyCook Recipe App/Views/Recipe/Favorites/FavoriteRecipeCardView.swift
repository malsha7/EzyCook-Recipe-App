//
//  FavoriteRecipeCardView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-17.
//

import SwiftUI

struct FavoriteRecipeCardView: View {
    
    let recipe: Recipe
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        
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
            
            
            VStack(alignment: .leading, spacing: 4) {
                
                
                Spacer(minLength: 8)
                
                
                HStack {
                    Text(recipe.title)
                        .font(.sfProMedium(size: 16))
                        .foregroundColor(.appWhite)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "heart.fill")
                        .foregroundColor(.appWhite)
                }
                
                
                HStack(spacing: 4) {
                    Text("Time:")
                        .font(.sfProRegular(size: 12))
                        .foregroundColor(.appWhite.opacity(0.7))
                    Text(recipe.mealTime ?? "N/A")
                        .font(.sfProRegular(size: 12))
                        .foregroundColor(.appWhite)
                }
                
                
                if let servings = recipe.servings {
                    Text("Servings: \(servings)")
                        .font(.sfProRegular(size: 10))
                        .foregroundColor(.appWhite.opacity(0.7))
                }
                
                Spacer()
                
               
                HStack {
                    Spacer()
                    Button(action: { onTap() }) {
                        Text("View")
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appWhite)
                            .frame(width: 90, height: 30)
                            .background(Color.appWhite.opacity(0.3))
                            .cornerRadius(12)
                    }
                }
            }
            .frame(height: 86)
        }
        .padding(10)
        .frame(width: 332, height: 125)
        .background(Color.appWhite.opacity(0.3))
        .cornerRadius(12)
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(role: .destructive) { onDelete() } label: {
                Label("Remove from Favorites", systemImage: "trash")
            }
        }
        
    }
}

//#Preview {
//    FavoriteRecipeCardView()
//}

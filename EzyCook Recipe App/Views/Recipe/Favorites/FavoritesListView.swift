//
//  FavoritesListView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-17.
//

import SwiftUI

struct FavoritesListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRecipe: Recipe?
    @State private var favorites: [Recipe] = []
    @Binding var selectedTab: Int
    @State private var showMyRecipes = false
    
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack(spacing: 16) {
                
               
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.appBlue)
                            Text("Back")
                                .foregroundColor(.appBlue)
                                .font(.sfProMedium(size: 16))
                        }
                    }
                    
                    Text("Favorites List")
                        .font(.sfProBold(size: 16))
                        .foregroundColor(.appWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: { showMyRecipes = true }) {
                                            Text("My Recipes")
                                                .font(.sfProMedium(size: 16))
                                                .foregroundColor(.appBlue)
                                        }
                }
                .padding(.horizontal)
                
               
                Rectangle()
                    .fill(Color.appWhite.opacity(0.25))
                    .frame(height: 1)
                
                
                if favorites.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.appWhite.opacity(0.5))
                        Text("No favorites yet")
                            .font(.sfProMedium(size: 18))
                            .foregroundColor(.appWhite)
                        Text("Tap the heart icon on recipes to save them here")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                } else {
                    List {
                        ForEach(favorites) { recipe in
                            FavoriteRecipeCardView(
                                recipe: recipe,
                                onTap: { selectedRecipe = recipe },
                                onDelete: { removeFromFavorites(recipe) }
                            )
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    removeFromFavorites(recipe)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.appBlack)
                }
                
                Spacer(minLength: 120)
            }
            .padding()
            .background(Color.appBlack.ignoresSafeArea())
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(item: $selectedRecipe) { recipe in
               // FavoriteRecipeDetailsView(recipe: recipe)
            }
            .fullScreenCover(isPresented: $showMyRecipes) {
               // MyRecipesView(selectedTab: $selectedTab)
            }
            
            .onAppear { loadFavorites() }
            
            
            BottomNavBar(selectedTab: $selectedTab)
                .padding(.bottom, 20)
        }
    }
    
   
    private func loadFavorites() {
        favorites = CoreDataManager.shared.fetchAllRecipes()
    }
    
    private func removeFromFavorites(_ recipe: Recipe) {
        CoreDataManager.shared.deleteRecipe(recipe)
        loadFavorites()
    }
        
   
}

//#Preview {
//    FavoritesListView()
//}

//
//  MyRecipesView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-19.
//

import SwiftUI

struct MyRecipesView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRecipe: Recipe?
    @State private var showAddNewRecipe = false
    
    @StateObject private var vm = RecipeViewModel()
    
   
    
    var body: some View {
        VStack(spacing: 16) {
            
            // top navigation row
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.appBlue)
                        Text("Back")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
                
                Text("My Recipes")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                // "+ Add" button navigate to AddNewRecipeView
                Button(action: {
                    showAddNewRecipe = true
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "plus")
                            .foregroundColor(.appBlue)
                        Text("Add")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
            }
            
            // divider
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // myrecipe list with swipe-to-delete
            Group {
                if vm.isLoading {
                    ProgressView("Loading recipes...")
                        .foregroundColor(.appWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 40)
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                            .font(.system(size: 40))
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 40)
                } else if vm.myRecipes.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "fork.knife")
                            .font(.system(size: 48))
                            .foregroundColor(.appWhite.opacity(0.5))
                        
                        Text("No recipes yet")
                            .font(.sfProMedium(size: 18))
                            .foregroundColor(.appWhite)
                        
                        Text("Add your first recipe using the + button above")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 40)
                } else {
                    List {
                        ForEach(vm.myRecipes) { recipe in
                            MyRecipeCardView(recipe: recipe) {
                                selectedRecipe = recipe
                            }
                            .listRowBackground(Color.clear)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    if let index = vm.myRecipes.firstIndex(where: { $0.id == recipe.id }) {
                                        vm.myRecipes.remove(at: index)
                                    }
                                  
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.appBlack)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .navigationBarHidden(true)
        .fullScreenCover(item: $selectedRecipe) { recipe in
            MyRecipeDetailsView(recipe: recipe)
        }
        .sheet(isPresented: $showAddNewRecipe) {
            AddNewRecipeView()
        }
        .onAppear {
            vm.getMyRecipes()
        }
    }
}

#Preview {
    MyRecipesView()
}

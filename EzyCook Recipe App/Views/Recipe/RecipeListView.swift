//
//  RecipeListView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import SwiftUI

struct RecipeListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRecipe: Recipe?
    
    // parameters from previous screens
    let selectedTools: [String]
    let selectedMealTime: String
    let selectedIngredients: [String]
    
    //  initializer
        init() {
            self.selectedTools = []
            self.selectedMealTime = ""
            self.selectedIngredients = []
        }
        
        //  initializer with parameters
        init(selectedTools: [String], selectedMealTime: String, selectedIngredients: [String]) {
            self.selectedTools = selectedTools
            self.selectedMealTime = selectedMealTime
            self.selectedIngredients = selectedIngredients
        }
    
    // sample recipe data
    var recipes: [Recipe] {
        //  filtering logic considering selectedTools, selectedMealTime, selectedIngredients
        let allRecipes = [
            Recipe(
                name: "Egg Fried Noodles",
                time: "20min",
                tools: "Microwave",
                imageName: "egg_fried_noodles"
            ),
            Recipe(
                name: "Chicken Rice",
                time: "30min",
                tools: "Gas Cooker",
                imageName: "chicken_rice"
            ),
            Recipe(
                name: "Quick Pasta",
                time: "15min",
                tools: "Gas Cooker",
                imageName: "quick_pasta"
            ),
            Recipe(
                name: "Microwave Mug Cake",
                time: "5min",
                tools: "Microwave",
                imageName: "mug_cake"
            )
        ]
        
        // filter recipes consider selected tools
        if selectedTools.isEmpty {
            return allRecipes
        } else {
            return allRecipes.filter { recipe in
                selectedTools.contains(recipe.tools)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            // top navigation row
            HStack {
                Button(action: {
                    // back to previous screen
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
                
                Text("Recipe List")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    // filter or search action
                    print("Filter recipes")
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.appBlue)
                        Text("Filter")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
            }
            
            // divider line
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // show selected criteria
            VStack(alignment: .leading, spacing: 8) {
                if !selectedMealTime.isEmpty {
                    HStack {
                        Text("Meal Time:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedMealTime)
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                    }
                }
                
                if !selectedTools.isEmpty {
                    HStack {
                        Text("Tools:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedTools.joined(separator: ", "))
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                    }
                }
                
                if !selectedIngredients.isEmpty {
                    HStack {
                        Text("Ingredients:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedIngredients.joined(separator: ", "))
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                            .lineLimit(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            
            // recipe cards
            ScrollView {
                VStack(spacing: 16) {
                    if recipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 48))
                                .foregroundColor(.appWhite.opacity(0.5))
                            
                            Text("No recipes found")
                                .font(.sfProMedium(size: 18))
                                .foregroundColor(.appWhite)
                            
                            Text("Try adjusting your selections to find more recipes")
                                .font(.sfProRegular(size: 14))
                                .foregroundColor(.appWhite.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                    } else {
                        ForEach(recipes, id: \.name) { recipe in
                            RecipeCardView(recipe: recipe) {
                                selectedRecipe = recipe
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .fullScreenCover(item: $selectedRecipe) { recipe in
            RecipeDetailsView(recipe: recipe)
        }
    }
}


struct RecipeDetailsView: View {
    let recipe: Recipe
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
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
                
                Text(recipe.name)
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(width: 60)
            }
            
            // divider
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // recipe image
            AsyncImage(url: URL(string: recipe.imageName)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appWhite.opacity(0.1))
                    .overlay(
                        Image("recipe image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // recipe details
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("Cooking Time")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(recipe.time)
                            .font(.sfProMedium(size: 16))
                            .foregroundColor(.appWhite)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Required Tools")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(recipe.tools)
                            .font(.sfProMedium(size: 16))
                            .foregroundColor(.appWhite)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Instructions")
                        .font(.sfProBold(size: 18))
                        .foregroundColor(.appWhite)
                    
                    Text("Detailed cooking instructions would go here. This is a placeholder for the actual recipe steps.")
                        .font(.sfProRegular(size: 14))
                        .foregroundColor(.appWhite.opacity(0.8))
                        .multilineTextAlignment(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
    }
}



#Preview {
    RecipeListView()
}

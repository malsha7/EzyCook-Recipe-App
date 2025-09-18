//
//  RecipeViewModel.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-13.
//

import Foundation
import SwiftUI



class RecipeViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var createdRecipe: Recipe?
    @Published var myRecipes: [Recipe] = []
    @Published var filteredRecipes: [Recipe] = []
    
    @Published var selectedTools: [String] = []
    @Published var selectedMealTime: String = ""
    @Published var selectedIngredients: [String] = []
    
    @Published var recipeErrorMessage: String?
    @Published var isLoadingRecipe = false
    @Published var isLoadingSuggestions = false
    
    func createRecipe(
        title: String,
        description: String,
        ingredients: [Ingredient],
        mealTime: String?,
        servings: Int,
        image: UIImage?
    ) {
        guard let token = KeychainHelper.shared
            .load(key: "auth_token")
            .flatMap({ String(data: $0, encoding: .utf8) }) else {
            print("No token found for createRecipe")
            self.errorMessage = "Not logged in."
            return
        }

        print("ViewModel: Creating recipe with token: \(token.prefix(5))...")

        isLoading = true
        errorMessage = nil
        createdRecipe = nil

        RecipeService.shared.createRecipe(
            title: title,
            description: description,
            ingredients: ingredients,
            mealTime: mealTime,
            servings: servings,
            image: image,
            token: token
        ) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false

                switch result {
                case .success(let recipe):
                    print("Recipe created successfully in ViewModel: \(recipe.title)")
                    self.createdRecipe = recipe
                case .failure(let error):
                    print("Recipe creation failed in ViewModel: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getMyRecipes() {
        guard let token = KeychainHelper.shared
            .load(key: "auth_token")
            .flatMap({ String(data: $0, encoding: .utf8) }) else {
            print("No token found for fetching recipes")
            self.errorMessage = "Not logged in."
            return
        }

        print("Fetching my recipes with token: \(token.prefix(5))...")

        isLoading = true
        errorMessage = nil

        RecipeService.shared.getMyRecipes(token: token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipes):
                    print("Loaded \(recipes.count) recipes")
                    self.myRecipes = recipes
                case .failure(let error):
                    print("Failed to load recipes: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

    
    func filterRecipes() {
        guard let token = KeychainHelper.shared
            .load(key: "auth_token")
            .flatMap({ String(data: $0, encoding: .utf8) }) else {
            print("No token found for filtering recipes")
            self.errorMessage = "Not logged in."
            return
        }

        print("Filtering recipes with tools: \(selectedTools), mealTime: \(selectedMealTime), ingredients: \(selectedIngredients)")

        isLoading = true
        errorMessage = nil

        RecipeService.shared.filterRecipes(
            tools: selectedTools,
            mealTime: selectedMealTime.isEmpty ? nil : selectedMealTime,
            ingredients: selectedIngredients,
            token: token
        ) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipes):
                    print("Loaded \(recipes.count) filtered recipes")
                    self.filteredRecipes = recipes
                case .failure(let error):
                    print("Failed to filter recipes: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}

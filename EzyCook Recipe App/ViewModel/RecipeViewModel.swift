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
    @Published var suggestedRecipes: [RecipeSuggestion] = []
    @Published var systemRecipes: [Recipe] = []
    @Published var selectedRecipe: Recipe?
    
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
    
    func suggestRecipes(query: String) {
        guard let token = KeychainHelper.shared
            .load(key: "auth_token")
            .flatMap({ String(data: $0, encoding: .utf8) }) else {
            print("No token found for suggest recipes")
            self.errorMessage = "Not logged in."
            return
        }

        print("Suggesting recipes for query: \(query)")

        isLoading = true
        errorMessage = nil

        RecipeService.shared.suggestRecipes(query: query, token: token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let suggestions):
                    print("Loaded \(suggestions.count) recipe suggestions")
                    self.suggestedRecipes = suggestions
                case .failure(let error):
                    print("Failed to load suggested recipes: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getRecipeDetails(id: String, completion: (() -> Void)? = nil) {
        guard let token = KeychainHelper.shared
            .load(key: "auth_token")
            .flatMap({ String(data: $0, encoding: .utf8) }) else {
            print("No token found for getRecipeDetails")
            self.errorMessage = "Not logged in."
            return
        }

        print("ViewModel: Fetching recipe details for id = \(id)")

        isLoading = true
        errorMessage = nil

        RecipeService.shared.fetchRecipeById(id: id, token: token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipe):
                    print("ViewModel: Got recipe → \(recipe.title)")
                    self.selectedRecipe = recipe
                    completion?()
                case .failure(let error):
                    print("ViewModel: Failed to fetch recipe details → \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func getAllRecipes() {
        print("Fetching all system recipes...")

        isLoading = true
        errorMessage = nil

        RecipeService.shared.getAllRecipes { [weak self] (result: Result<[Recipe], Error>) in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let recipes):
                    print("Loaded \(recipes.count) system recipes")
                    self.systemRecipes = recipes
                case .failure(let error):
                    print("Failed to load system recipes: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func deleteRecipe(id: String) {
        guard let tokenData = KeychainHelper.shared.load(key: "auth_token"),
              let token = String(data: tokenData, encoding: .utf8) else {
            print("No token found for deleteRecipe")
            self.errorMessage = "Not logged in."
            return
        }
        
        print("ViewModel: Deleting recipe with id = \(id), token = \(token.prefix(5))...")
        
        isLoading = true
        errorMessage = nil
        
        RecipeService.shared.deleteRecipeById(id: id, token: token) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let message):
                    print("ViewModel: Recipe deleted successfully → \(message)")
                    self.myRecipes.removeAll { $0.id == id }
                    
                case .failure(let error):
                    print("ViewModel: Failed to delete recipe → \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }


    
}

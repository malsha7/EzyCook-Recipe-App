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
    
    func createRecipe(
        title: String,
        description: String,
        ingredients: [Ingredient],
        mealTime: String?,
        servings: Int,
        image: UIImage?
    ) {
       
        let possibleTokens = [
            UserDefaults.standard.string(forKey: "auth_token"),
            UserDefaults.standard.string(forKey: "auth_Token"),
            UserDefaults.standard.string(forKey: "authToken"),
            UserDefaults.standard.string(forKey: "token"),
            UserDefaults.standard.string(forKey: "accessToken"),
            UserDefaults.standard.string(forKey: "userToken")
        ]
        
        guard let token = possibleTokens.compactMap({ $0 }).first else {
            print("No token found. Available keys:")
           
            for key in UserDefaults.standard.dictionaryRepresentation().keys {
                if key.contains("token") || key.contains("Token") || key.contains("auth") {
                    print("  \(key): \(UserDefaults.standard.string(forKey: key) ?? "nil")")
                }
            }
            self.errorMessage = "Not logged in."
            return
        }
      
        print(" ViewModel: Creating recipe with token: \(token.prefix(5))...")
        
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
                    print(" Recipe created successfully in ViewModel: \(recipe.title)")
                    self.createdRecipe = recipe
                case .failure(let error):
                    print("Recipe creation failed in ViewModel: \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    
}

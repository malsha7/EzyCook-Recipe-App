//
//  CoreDataManager.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-17.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    private init(modelName: String = "FavouriteRecipes") {
        container = NSPersistentContainer(name: modelName)

       
        if let desc = container.persistentStoreDescriptions.first {
            desc.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
            desc.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        }

        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            } else {
                print("Core Data loaded: \(desc.url?.absoluteString ?? "no url")")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

   
    private func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do { try context.save() }
            catch { print("Save error: \(error.localizedDescription)") }
        }
    }

   
    func addRecipe(_ recipe: Recipe) {
        let context = container.viewContext

        if let existing = fetchFavouriteEntity(by: recipe.id) {
            
            existing.title = recipe.title
            existing.recipeDescription = recipe.description
            existing.mealTime = recipe.mealTime
            existing.servings = Int16(recipe.servings ?? 0)
            existing.imageUrl = recipe.imageUrl
            existing.videoUrl = recipe.videoUrl
            existing.createdAt = recipe.createdAt
            existing.updatedAt = recipe.updatedAt

            if let encoded = try? JSONEncoder().encode(recipe.ingredients) {
                existing.ingredientsData = encoded
            }
            if let tools = recipe.tools, let encoded = try? JSONEncoder().encode(tools) {
                existing.toolsData = encoded
            }

            saveContext()
            return
        }

       
        let fav = FavouriteRecipe(context: context)
        fav.id = recipe.id
        fav.title = recipe.title
        fav.recipeDescription = recipe.description
        fav.mealTime = recipe.mealTime
        fav.servings = Int16(recipe.servings ?? 0)
        fav.imageUrl = recipe.imageUrl
        fav.videoUrl = recipe.videoUrl
        fav.createdAt = recipe.createdAt
        fav.updatedAt = recipe.updatedAt

        if let encoded = try? JSONEncoder().encode(recipe.ingredients) {
            fav.ingredientsData = encoded
        }
        if let tools = recipe.tools, let encoded = try? JSONEncoder().encode(tools) {
            fav.toolsData = encoded
        }

        saveContext()
    }

    
    func deleteRecipe(by id: String) {
        guard let obj = fetchFavouriteEntity(by: id) else { return }
        container.viewContext.delete(obj)
        saveContext()
    }

    func deleteRecipe(_ recipe: Recipe) {
        deleteRecipe(by: recipe.id)
    }

    
    func fetchAllRecipes() -> [Recipe] {
        let request: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            let results = try container.viewContext.fetch(request)
            return results.compactMap { toRecipe(from: $0) }
        } catch {
            print("fetchAllRecipes error: \(error.localizedDescription)")
            return []
        }
    }

  
    func isFavorite(id: String) -> Bool {
        let request: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        do {
            let count = try container.viewContext.count(for: request)
            return count > 0
        } catch {
            print("isFavorite error: \(error.localizedDescription)")
            return false
        }
    }

   
    func toggleFavorite(_ recipe: Recipe) {
        if isFavorite(id: recipe.id) {
            deleteRecipe(by: recipe.id)
        } else {
            addRecipe(recipe)
        }
    }

   
    private func fetchFavouriteEntity(by id: String) -> FavouriteRecipe? {
        let request: NSFetchRequest<FavouriteRecipe> = FavouriteRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        do { return try container.viewContext.fetch(request).first }
        catch {
            print("fetchFavouriteEntity error: \(error.localizedDescription)")
            return nil
        }
    }

   
    private func toRecipe(from fav: FavouriteRecipe) -> Recipe {
        let ingredients: [Ingredient]
        if let data = fav.ingredientsData,
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            ingredients = decoded
        } else { ingredients = [] }

        var tools: [String]? = nil
        if let data = fav.toolsData,
           let decoded = try? JSONDecoder().decode([String].self, from: data) {
            tools = decoded
        }

        return Recipe(
            id: fav.id ?? UUID().uuidString,
            title: fav.title ?? "",
            description: fav.recipeDescription ?? "",
            ingredients: ingredients,
            tools: tools,
            mealTime: fav.mealTime,
            servings: Int(fav.servings),
            imageUrl: fav.imageUrl,
            videoUrl: fav.videoUrl,
            createdAt: fav.createdAt,
            updatedAt: fav.updatedAt
        )
    }
    
}

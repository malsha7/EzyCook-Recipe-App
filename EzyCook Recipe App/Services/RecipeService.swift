//
//  RecipeService.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-13.
//

import Foundation
import UIKit

class RecipeService {
    static let shared = RecipeService()
    private init() {}
    
    func createRecipe(
        title: String,
        description: String,
        ingredients: [Ingredient],
        mealTime: String?,
        servings: Int,
        image: UIImage?,
        token: String,
        completion: @escaping (Result<Recipe, Error>) -> Void
    ) {
        print("createRecipe called")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes/my-recipes") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 60.0
        
        var body = Data()
        
        func appendFormField(name: String, value: String, to data: inout Data) {
            data.append("--\(boundary)\r\n")
            data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
            data.append("\(value)\r\n")
        }
        
        func appendFileField(name: String, filename: String, data: Data, mimeType: String, to bodyData: inout Data) {
            bodyData.append("--\(boundary)\r\n")
            bodyData.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
            bodyData.append("Content-Type: \(mimeType)\r\n\r\n")
            bodyData.append(data)
            bodyData.append("\r\n")
        }
        
        
        appendFormField(name: "title", value: title, to: &body)
        appendFormField(name: "description", value: description, to: &body)
        appendFormField(name: "servings", value: "\(servings)", to: &body)
        if let mealTime = mealTime {
            appendFormField(name: "mealTime", value: mealTime, to: &body)
        }
        
       
        if let ingredientsData = try? JSONEncoder().encode(ingredients),
           let ingredientsJSON = String(data: ingredientsData, encoding: .utf8) {
            appendFormField(name: "ingredients", value: ingredientsJSON, to: &body)
        }
        
        
        if let image = image {
            let maxWidth: CGFloat = 1024
            let resizedImage = image.resized(toMaxWidth: maxWidth) ?? image
            if let imageData = resizedImage.jpegData(compressionQuality: 0.7) {
                print(" Uploading image: \(imageData.count / 1024) KB")
                appendFileField(name: "image", filename: "recipe.jpg", data: imageData, mimeType: "image/jpeg", to: &body)
            }
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        print(" Sending request to: \(url.absoluteString)")
        print(" Body size: \(body.count) bytes")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print(" Network error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(" HTTP Status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("No data received")
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                if let str = String(data: data, encoding: .utf8) {
                    print("Response Data: \(str)")
                }
                
                do {
                    // try decode recipe directly first
                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                    print("Recipe decoded: \(recipe.title)")
                    completion(.success(recipe))
                } catch {
                    print("Decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getMyRecipes(token: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
            guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes/my-recipes") else {
                completion(.failure(NSError(domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 60.0

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Network error: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP Status: \(httpResponse.statusCode)")
                    }

                    guard let data = data else {
                        completion(.failure(NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                        return
                    }

                    if let str = String(data: data, encoding: .utf8) {
                        print("Response Data: \(str)")
                    }

                    do {
                        let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                        print("Decoded \(recipes.count) recipes")
                        completion(.success(recipes))
                    } catch {
                        print(" Decoding error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }.resume()
        }
    
    func loadImage(url: URL, token: String, completion: @escaping (UIImage?) -> Void) {
           var request = URLRequest(url: url)
           request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           
           URLSession.shared.dataTask(with: request) { data, _, _ in
               guard let data = data, let image = UIImage(data: data) else {
                   completion(nil)
                   return
               }
               completion(image)
           }.resume()
       }
    
    func filterRecipes(
            tools: [String],
            mealTime: String?,
            ingredients: [String],
            token: String,
            completion: @escaping (Result<[Recipe], Error>) -> Void
        ) {
            guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes/filter") else {
                completion(.failure(NSError(domain: "", code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.timeoutInterval = 60.0

            // request body matching the backend controller
            let body: [String: Any] = [
                "tools": tools,
                "mealTime": mealTime ?? "",
                "ingredients": ingredients
            ]

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Network error: \(error.localizedDescription)")
                        completion(.failure(error))
                        return
                    }

                    if let httpResponse = response as? HTTPURLResponse {
                        print("HTTP Status: \(httpResponse.statusCode)")
                    }

                    guard let data = data else {
                        completion(.failure(NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                        return
                    }

                    if let str = String(data: data, encoding: .utf8) {
                        print("Response Data: \(str)")
                    }

                    do {
                        let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                        print("Decoded \(recipes.count) filtered recipes")
                        completion(.success(recipes))
                    } catch {
                        print("Decoding error: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            }.resume()
        }

    
    func suggestRecipes(
        query: String,
        token: String,
        completion: @escaping (Result<[RecipeSuggestion], Error>) -> Void
    ) {
        guard var components = URLComponents(string: "\(APIService.shared.baseURL)/api/recipes/suggest/search") else {
            completion(.failure(NSError(domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        
        components.queryItems = [URLQueryItem(name: "query", value: query)]

        guard let url = components.url else {
            completion(.failure(NSError(domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid query URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30.0

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Suggest network error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    print("Suggest HTTP Status: \(httpResponse.statusCode)")
                }

                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }

                if let str = String(data: data, encoding: .utf8) {
                    print("Suggest Response Data: \(str)")
                }

                do {
                    
                    let suggestions = try JSONDecoder().decode([RecipeSuggestion].self, from: data)
                    print("Decoded \(suggestions.count) recipe suggestions")
                    completion(.success(suggestions))
                } catch {
                    print("Suggest decoding error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    func fetchRecipeById(
        id: String,
        token: String,
        completion: @escaping (Result<Recipe, Error>) -> Void
    ) {
        guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes/\(id)") else {
            completion(.failure(NSError(domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid recipe ID URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30.0
        
        print("FetchRecipeById Request → \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("FetchRecipeById Network Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("FetchRecipeById HTTP Status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("FetchRecipeById No Data")
                    completion(.failure(NSError(domain: "", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                if let raw = String(data: data, encoding: .utf8) {
                    print("FetchRecipeById Raw Response: \(raw)")
                }
                
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                    print("FetchRecipeById Decoded Recipe: \(recipe.title)")
                    completion(.success(recipe))
                } catch {
                    print("FetchRecipeById Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func getAllRecipes(completion: @escaping (Result<[Recipe], Error>) -> Void) {
           guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes") else {
               completion(.failure(NSError(domain: "", code: -1,
                   userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "GET"
           request.timeoutInterval = 60.0

           URLSession.shared.dataTask(with: request) { data, response, error in
               DispatchQueue.main.async {
                   if let error = error {
                       print("Network error: \(error.localizedDescription)")
                       completion(.failure(error))
                       return
                   }

                   if let httpResponse = response as? HTTPURLResponse {
                       print("HTTP Status: \(httpResponse.statusCode)")
                   }

                   guard let data = data else {
                       completion(.failure(NSError(domain: "", code: -1,
                           userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                       return
                   }

                   if let str = String(data: data, encoding: .utf8) {
                       print("Response Data: \(str)")
                   }

                   do {
                       let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                       print("Decoded \(recipes.count) system recipes")
                       completion(.success(recipes))
                   } catch {
                       print("Decoding error: \(error.localizedDescription)")
                       completion(.failure(error))
                   }
               }
           }.resume()
       }
    
    func deleteRecipeById(
        id: String,
        token: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let url = URL(string: "\(APIService.shared.baseURL)/api/recipes/my-recipes/\(id)") else {
            completion(.failure(NSError(domain: "", code: -1,
            userInfo: [NSLocalizedDescriptionKey: "Invalid recipe ID URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30.0
        
        print("DeleteRecipeById Request → \(url.absoluteString)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("DeleteRecipeById Network Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("DeleteRecipeById HTTP Status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("DeleteRecipeById No Data")
                    completion(.failure(NSError(domain: "", code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                if let raw = String(data: data, encoding: .utf8) {
                    print("DeleteRecipeById Raw Response: \(raw)")
                }
                
                do {
                    let result = try JSONDecoder().decode([String: String].self, from: data)
                    let message = result["message"] ?? "Recipe deleted successfully"
                    print("DeleteRecipeById Success: \(message)")
                    completion(.success(message))
                } catch {
                    print("DeleteRecipeById Decoding Error: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
}


private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

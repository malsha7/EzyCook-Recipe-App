//
//  Recipe.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import Foundation



struct Ingredient: Codable, Equatable {
    let name: String
    let quantity: String?
}

struct RecipeSuggestion: Codable, Identifiable {
    let id: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
    }
}

// recipe model matching with backend response
struct Recipe: Codable, Identifiable, Equatable {
    let id: String
    var title: String
    var description: String
    var ingredients: [Ingredient]
    var tools: [String]?
    var mealTime: String?
    var servings: Int?
    var imageUrl: String?
    var createdAt: String?
    var updatedAt: String?
    
    // codingkeys  map backend field names
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case description
        case ingredients
        case tools
        case mealTime
        case servings
        case imageUrl = "image"
        case createdAt
        case updatedAt
    }
    
   
    var displayImageURL: URL? {
        guard let image = imageUrl?.trimmingCharacters(in: .whitespacesAndNewlines),
              !image.isEmpty else {
            print("displayImageURL: imageUrl is empty or nil")
            return nil
        }
        
        if image.hasPrefix("http") {
            
            let url = URL(string: image)
            print("displayImageURL (system): \(url?.absoluteString ?? "invalid URL")")
            return url
        } else {
           
            let path = image.hasPrefix("/") ? String(image.dropFirst()) : image
            let fullURL = "https://ezycook.duckdns.org/\(path)"
            let encodedURL = fullURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            let url = encodedURL.flatMap { URL(string: $0) }
            print("displayImageURL (user-uploaded): \(url?.absoluteString ?? "invalid URL")")
            return url
        }
    }
    
}

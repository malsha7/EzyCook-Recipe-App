//
//  Recipe.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import Foundation


struct Ingredient: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: String
}

struct Recipe: Identifiable{
    
    let id = UUID()
    let name: String
    let time: String
    let tools: String
    var ingredients: [Ingredient]
    let imageName: String
    
    
}

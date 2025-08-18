//
//  Recipe.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import Foundation

struct Recipe: Identifiable{
    
    let id = UUID()
    let name: String
    let time: String
    let tools: String
    let imageName: String
    
    
}

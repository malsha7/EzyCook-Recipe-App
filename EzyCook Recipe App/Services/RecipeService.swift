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
    
    
}


private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

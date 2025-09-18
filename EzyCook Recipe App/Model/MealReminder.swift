//
//  MealReminder.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-18.
//

import Foundation

struct MealReminder: Codable, Identifiable, Equatable {
    let id: UUID
    let title: String
    let date: Date
    
    
    init(id: UUID = UUID(), title: String, date: Date) {
        self.id = id
        self.title = title
        self.date = date
    }
    
   
    var formattedDate: String {
        date.formatted(date: .abbreviated, time: .shortened)
    }
    
    
    static func == (lhs: MealReminder, rhs: MealReminder) -> Bool {
        lhs.id == rhs.id
    }
}

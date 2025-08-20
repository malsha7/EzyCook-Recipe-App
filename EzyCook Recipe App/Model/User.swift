//
//  User.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import Foundation

//  matching  backend user response for login/signup
struct User: Decodable {
    let _id: String
    let username: String
    let email: String
    let token: String
}

// generic message response from backend
struct MessageResponse: Decodable {
    let message: String
}

// user profile for update
struct UserProfile: Decodable {
    let _id: String
    var username: String
    var email: String
    var name: String?
    var phoneNumber: String?
    var profileImage: String?
}

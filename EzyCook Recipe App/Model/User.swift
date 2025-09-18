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
    
    var displayImageURL: URL? {
        guard let image = profileImage?.trimmingCharacters(in: .whitespacesAndNewlines),
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

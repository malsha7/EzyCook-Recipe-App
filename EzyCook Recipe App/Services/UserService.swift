//
//  UserService.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import Foundation
import Combine
import SwiftUI

class UserService {
    
    static let shared = UserService()
    private init() {}
    
    // signup
    func signup(username: String, email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let body: [String: Any] = [
            "username": username,
            "email": email,
            "password": password
        ]
        APIService.shared.request(url: "/api/users/signup", method: "POST", body: body, completion: completion)
    }

    // login
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let body: [String: Any] = [
            "username": username,
            "password": password
        ]
        APIService.shared.request(url: "/api/users/login", method: "POST", body: body, completion: completion)
    }

    // forgot password (send OTP)
   func sendOtp(email: String, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
       let body: [String: Any] = [
        "email": email
       ]
       APIService.shared.request(url: "/api/users/forgot-password", method: "POST", body: body, completion: completion)
   }


    // reset password
   func resetPassword(email: String, otp: String, newPassword: String, completion: @escaping (Result<MessageResponse, Error>) -> Void) {
        let body: [String: Any] = [
            "email": email,
            "otp": otp,
            "newPassword": newPassword
        ]
        APIService.shared.request(url: "/api/users/reset-password", method: "PUT", body: body, completion: completion)
    }


    // get profile
    func getProfile(token: String, completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        APIService.shared.request(url: "/api/users/profile", method: "GET", headers: headers, completion: completion)
    }

    // edit profile
    func updateProfile(token: String, profile: [String: Any], completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        APIService.shared.request(url: "/api/users/profile", method: "PUT", body: profile, headers: headers, completion: completion)
    }

    
}



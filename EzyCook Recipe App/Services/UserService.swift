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
        print("UserService: Getting profile with token: \(token.prefix(10))")
        
        guard let url = URL(string: "\(APIService.shared.baseURL)/api/users/profile") else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
            completion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 30.0
        
        print(" URL: \(url.absoluteString)")
        print(" Headers: \(request.allHTTPHeaderFields ?? [:])")
        
        // start the task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          
            DispatchQueue.main.async {
                self.handleGetProfileResponse(data: data, response: response, error: error, completion: completion)
            }
        }
        
        task.resume()
        print("UserService: Request sent!")
    }

    private func handleGetProfileResponse(
        data: Data?,
        response: URLResponse?,
        error: Error?,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {
       
        if let error = error {
            print("UserService: Network error - \(error.localizedDescription)")
            completion(.failure(error))
            return
        }
        
        // check HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            print("UserService: Response status - \(httpResponse.statusCode)")
            
         
            if httpResponse.statusCode != 200 {
                print("Response headers: \(httpResponse.allHeaderFields)")
            }
        }
        
      
        guard let data = data else {
            print("UserService: No response data")
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received from server"])
            completion(.failure(error))
            return
        }
        
        
        if let responseString = String(data: data, encoding: .utf8) {
            print("UserService: Server response - \(responseString)")
        }
        
       
        do {
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("UserService: Invalid JSON format")
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
                completion(.failure(error))
                return
            }
            
          
            if let message = json["message"] as? String,
               let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 400 {
                print(" UserService: Server error - \(message)")
                let error = NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                completion(.failure(error))
                return
            }
            
         
            guard let userData = json["user"] as? [String: Any] else {
                print("UserService: No user data in response")
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user data in response"])
                completion(.failure(error))
                return
            }
            
           //convert to user profile data
            let userDataJSON = try JSONSerialization.data(withJSONObject: userData)
            let decoder = JSONDecoder()
            
          
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            decoder.dateDecodingStrategy = .formatted(formatter)
            
            let userProfile = try decoder.decode(UserProfile.self, from: userDataJSON)
            
            print(" UserService: Profile fetched successfully")
            print(" Profile: \(userProfile.username ?? "N/A")")
            
            completion(.success(userProfile))
            
        } catch let decodingError {
            print("UserService: JSON parsing error - \(decodingError)")
            if let decodingError = decodingError as? DecodingError {
                print("Decoding error details: \(decodingError)")
            }
            completion(.failure(decodingError))
        }
    }


    
    
    // edit profile
    func updateProfile(token: String, profile: [String: Any], completion: @escaping (Result<UserProfile, Error>) -> Void) {
        let headers = ["Authorization": "Bearer \(token)"]
        APIService.shared.request(url: "/api/users/profile", method: "PUT", body: profile, headers: headers, completion: completion)
    }

    
}

// for multi part from data
private extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

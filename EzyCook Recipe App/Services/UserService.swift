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
    
    // auth token
    var authToken: String? {
        get {
            if let data = KeychainHelper.shared.load(key: "auth_token") {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
        set {
            if let token = newValue {
                let data = Data(token.utf8)
                KeychainHelper.shared.save(key: "auth_token", data: data)
            } else {
                KeychainHelper.shared.delete(key: "auth_token")
            }
        }
    }
    
    
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
    func updateProfile(
            token: String,
            profile: [String: Any],
            image: UIImage?,
            completion: @escaping (Result<UserProfile, Error>) -> Void
        ) {
            let boundary = "Boundary-\(UUID().uuidString)"
            
            guard let url = URL(string: "\(APIService.shared.baseURL)/api/users/profile") else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                completion(.failure(error))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.timeoutInterval = 30.0
            
            var body = Data()
            
            print(" UserService: Creating multipart form data")
            print(" Boundary: \(boundary)")
            print(" URL: \(url.absoluteString)")
            
         
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
            
            
            for (key, value) in profile {
                if let stringValue = value as? String, !stringValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    appendFormField(name: key, value: stringValue, to: &body)
                    print(" Added field: \(key) = '\(stringValue)'")
                } else if let nonStringValue = value as? CustomStringConvertible {
                    let stringValue = String(describing: nonStringValue)
                    if !stringValue.isEmpty {
                        appendFormField(name: key, value: stringValue, to: &body)
                        print(" Added field: \(key) = '\(stringValue)'")
                    }
                } else {
                    print(" Skipped empty/invalid field: \(key)")
                }
            }
            
           
            if let image = image {
                print(" Processing image")
                
              
                let maxWidth: CGFloat = 1024
                let resizedImage = image.resized(toMaxWidth: maxWidth) ?? image
                print(" Original size: \(image.size), Resized: \(resizedImage.size)")
                
                // convert to JPEG with compression
                if let imageData = resizedImage.jpegData(compressionQuality: 0.7) {
                    appendFileField(
                        name: "profileImage",
                        filename: "profile.jpg",
                        data: imageData,
                        mimeType: "image/jpeg",
                        to: &body
                    )
                    print(" Added image: profileImage (\(imageData.count) bytes)")
                } else {
                    print(" Failed to convert image to JPEG data")
                }
            } else {
                print(" No image to upload")
            }
            
            // close multipart form
            body.append("--\(boundary)--\r\n")
            
            request.httpBody = body
            
            print(" Total request size: \(body.count) bytes")
            print(" Headers: \(request.allHTTPHeaderFields ?? [:])")
            
           
            if let bodyPreview = String(data: body.prefix(500), encoding: .utf8) {
                print(" Request body preview:")
                print(bodyPreview.replacingOccurrences(of: "\r\n", with: "\\r\\n"))
                print("...")
            }
            
            //  start the task
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
              
                DispatchQueue.main.async {
                    self.handleUpdateProfileResponse(data: data, response: response, error: error, completion: completion)
                }
            }
            
            task.resume()
            print("UserService: Request sent!")
        }
  
    
    private func handleUpdateProfileResponse(
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
                    print("UserService: Server error - \(message)")
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
                
              
                let userDataJSON = try JSONSerialization.data(withJSONObject: userData)
                let decoder = JSONDecoder()
                
              
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let updatedProfile = try decoder.decode(UserProfile.self, from: userDataJSON)
                
                print("UserService: Profile updated successfully")
                print("Updated profile: \(updatedProfile.username ?? "N/A")")
                
                completion(.success(updatedProfile))
                
            } catch let decodingError {
                print("UserService: JSON parsing error - \(decodingError)")
                if let decodingError = decodingError as? DecodingError {
                    print("Decoding error details: \(decodingError)")
                }
                completion(.failure(decodingError))
            }
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

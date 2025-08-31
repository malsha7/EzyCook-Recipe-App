//
//  UserViewModel.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import Foundation
import Combine
import SwiftUI

class UserViewModel: ObservableObject {
    
    // published properties
    @Published var user: User?              // login user data
    @Published var profile: UserProfile?    // profile info
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String? // for messages to "send otp " or "password reset success"
    
    
    private var cancellables = Set<AnyCancellable>()
    
    // auth token
    var authToken: String? {
        get { UserDefaults.standard.string(forKey: "auth_token") }
        set { UserDefaults.standard.set(newValue, forKey: "auth_token") }
    }
    
    // signup
    func signup(username: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        UserService.shared.signup(username: username, email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.authToken = user.token
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // login
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        isLoading = true
        UserService.shared.login(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let user):
                    self?.user = user
                    self?.authToken = user.token
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }
    
    // forgot password / send otp
       func sendOtp(email: String, completion: @escaping (Bool) -> Void) {
           isLoading = true
           UserService.shared.sendOtp(email: email) { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let messageResponse):
                       self?.successMessage = messageResponse.message
                       completion(true)
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                       completion(false)
                   }
               }
           }
       }
    
    
       
       // reset password
       func resetPassword(email: String, otp: String, newPassword: String, completion: @escaping (Bool) -> Void) {
           isLoading = true
           UserService.shared.resetPassword(email: email, otp: otp, newPassword: newPassword) { [weak self] result in
               DispatchQueue.main.async {
                   self?.isLoading = false
                   switch result {
                   case .success(let messageResponse):
                       self?.successMessage = messageResponse.message
                       completion(true)
                   case .failure(let error):
                       self?.errorMessage = error.localizedDescription
                       completion(false)
                   }
               }
           }
       }
    
    
    
    // get profile
    func getProfile() {
        guard let token = authToken else {
            
            errorMessage = "No authentication token"
            
            return }
        isLoading = true
        UserService.shared.getProfile(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let profile):
                    self?.profile = profile
                    self?.errorMessage = nil 
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // edit profile
    func updateProfile(
        name: String?,
        username: String?,
        email: String?,
        phoneNumber: String?,
        profileImage: UIImage?,
        completion: @escaping (Bool) -> Void
    ) {
        guard let token = authToken else { return }

        var profileData: [String: Any] = [:]
        if let name = name { profileData["name"] = name }
        if let username = username { profileData["username"] = username }
        if let email = email { profileData["email"] = email }
        if let phoneNumber = phoneNumber { profileData["phoneNumber"] = phoneNumber }

        isLoading = true
        UserService.shared.updateProfile(token: token, profile: profileData, image: profileImage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedProfile):
                    self?.profile = updatedProfile
                    completion(true)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                }
            }
        }
    }

    
    // logout
    func logout() {
        user = nil
        profile = nil
        authToken = nil
    }
    
    
}

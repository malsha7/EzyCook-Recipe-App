//
//  ValidationHelper.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-16.
//

import SwiftUI

struct ValidationHelper {
    
    
    // name vlidation
    static func validateName(_ name: String) -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return "Name is required"
        }
        
        if trimmedName.count < 2 {
            return "Name must be at least 2 characters"
        }
        
        if trimmedName.count > 50 {
            return "Name cannot exceed 50 characters"
        }
        
        // check if name contains only letters and spaces
        let nameRegex = "^[a-zA-Z\\s]+$"
        let namePredicate = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        if !namePredicate.evaluate(with: trimmedName) {
            return "Name can only contain letters and spaces"
        }
        
        return nil
    }
    
    // email validation
    static func validateEmail(_ email: String) -> String? {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            return "Email is required"
        }
        
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if !emailPredicate.evaluate(with: trimmedEmail) {
            return "Please enter a valid email address"
        }
        
        return nil
    }
    
    // username validation
    static func validateUsername(_ username: String) -> String? {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedUsername.isEmpty {
            return "Username is required"
        }
        
        if trimmedUsername.count < 3 {
            return "Username must be at least 3 characters"
        }
        
        if trimmedUsername.count > 20 {
            return "Username cannot exceed 20 characters"
        }
        
        // username can contain letters, numbers, underscores, and dots
        let usernameRegex = "^[a-zA-Z0-9._]+$"
        let usernamePredicate = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        
        if !usernamePredicate.evaluate(with: trimmedUsername) {
            return "Username can only contain letters, numbers, dots, and underscores"
        }
        
        return nil
    }
    
    // password validation
    static func validatePassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        
        if password.count < 8 {
            return "Password must be at least 8 characters"
        }
        
        if password.count > 128 {
            return "Password cannot exceed 128 characters"
        }
        
        // check for at least one uppercase letter
        let uppercaseRegex = ".*[A-Z].*"
        let uppercasePredicate = NSPredicate(format: "SELF MATCHES %@", uppercaseRegex)
        if !uppercasePredicate.evaluate(with: password) {
            return "Password must contain at least one uppercase letter"
        }
        
        // check for at least one lowercase letter
        let lowercaseRegex = ".*[a-z].*"
        let lowercasePredicate = NSPredicate(format: "SELF MATCHES %@", lowercaseRegex)
        if !lowercasePredicate.evaluate(with: password) {
            return "Password must contain at least one lowercase letter"
        }
        
        // check for at least one digit
        let digitRegex = ".*[0-9].*"
        let digitPredicate = NSPredicate(format: "SELF MATCHES %@", digitRegex)
        if !digitPredicate.evaluate(with: password) {
            return "Password must contain at least one number"
        }
        
        // check for at least one special character
        let specialCharRegex = ".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*"
        let specialCharPredicate = NSPredicate(format: "SELF MATCHES %@", specialCharRegex)
        if !specialCharPredicate.evaluate(with: password) {
            return "Password must contain at least one special character"
        }
        
        return nil
    }
    
    // confirm password validation
    static func validateConfirmPassword(_ password: String, confirmPassword: String) -> String? {
        if confirmPassword.isEmpty {
            return "Please confirm your password"
        }
        
        if password != confirmPassword {
            return "Passwords do not match"
        }
        
        return nil
    }
    
    // phone number validation
    static func validatePhoneNumber(_ phoneNumber: String) -> String? {
        let trimmedPhone = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedPhone.isEmpty {
            return "Phone number is required"
        }
        
        // remove all non-digit characters for validation
        let digitsOnly = trimmedPhone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        
        if digitsOnly.count < 10 {
            return "Phone number must be at least 10 digits"
        }
        
        if digitsOnly.count > 15 {
            return "Phone number cannot exceed 15 digits"
        }
        
        // normal phone format validation
        let phoneRegex = "^[+]?[0-9\\s\\-\\(\\)]+$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        if !phonePredicate.evaluate(with: trimmedPhone) {
            return "Please enter a valid phone number"
        }
        
        return nil
    }
    
    // signin password validation
    static func validateSignInPassword(_ password: String) -> String? {
        if password.isEmpty {
            return "Password is required"
        }
        
        if password.count < 6 {
            return "Password must be at least 6 characters"
        }
        
        return nil
    }
    
    // forgot password screen email validation
    static func validateResetEmail(_ email: String) -> String? {
        return validateEmail(email) // Reuse email validation
    }
    
    // validate sign In fields
    static func validateSignInFields(username: String, password: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if let usernameError = validateUsername(username) {
            errors["username"] = usernameError
        }
        
        if let passwordError = validateSignInPassword(password) {
            errors["password"] = passwordError
        }
        
        return errors
    }
    
    //  validate sign up fields
    static func validateSignUpFields(username: String, email: String, password: String, confirmPassword: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if let usernameError = validateUsername(username) {
            errors["username"] = usernameError
        }
        
        if let emailError = validateEmail(email) {
            errors["email"] = emailError
        }
        
        if let passwordError = validatePassword(password) {
            errors["password"] = passwordError
        }
        
        if let confirmPasswordError = validateConfirmPassword(password, confirmPassword: confirmPassword) {
            errors["confirmPassword"] = confirmPasswordError
        }
        
        return errors
    }
    
    // validate forgot password fields
    static func validateForgotPasswordFields(email: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if let emailError = validateResetEmail(email) {
            errors["email"] = emailError
        }
        
        return errors
    }
    
    // validate reset password fields
    static func validateResetPasswordFields(newPassword: String, confirmPassword: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if let passwordError = validatePassword(newPassword) {
            errors["newPassword"] = passwordError
        }
        
        if let confirmPasswordError = validateConfirmPassword(newPassword, confirmPassword: confirmPassword) {
            errors["confirmPassword"] = confirmPasswordError
        }
        
        return errors
    }
    
    //  validate all fields in profile
    static func validateAllFields(name: String, email: String, username: String, phoneNumber: String) -> [String: String] {
        var errors: [String: String] = [:]
        
        if let nameError = validateName(name) {
            errors["name"] = nameError
        }
        
        if let emailError = validateEmail(email) {
            errors["email"] = emailError
        }
        
        if let usernameError = validateUsername(username) {
            errors["username"] = usernameError
        }
        
        if let phoneError = validatePhoneNumber(phoneNumber) {
            errors["phoneNumber"] = phoneError
        }
        
        return errors
    }
    
    // password strong checking
    static func getPasswordStrength(_ password: String) -> PasswordStrength {
        if password.isEmpty {
            return .none
        }
        
        var score = 0
        
        // length checking
        if password.count >= 8 { score += 1 }
        if password.count >= 12 { score += 1 }
        
        // character type checking
        if password.range(of: "[A-Z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[a-z]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[0-9]", options: .regularExpression) != nil { score += 1 }
        if password.range(of: "[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]", options: .regularExpression) != nil { score += 1 }
        
        switch score {
        case 0...2:
            return .weak
        case 3...4:
            return .medium
        case 5...6:
            return .strong
        default:
            return .strong
        }
    }
}

// password strong enum
enum PasswordStrength {
    case none
    case weak
    case medium
    case strong
    
    var color: Color {
        switch self {
        case .none:
            return .clear
        case .weak:
            return .red
        case .medium:
            return .orange
        case .strong:
            return .green
        }
    }
    
    var text: String {
        switch self {
        case .none:
            return ""
        case .weak:
            return "Weak"
        case .medium:
            return "Medium"
        case .strong:
            return "Strong"
        }
    }
}

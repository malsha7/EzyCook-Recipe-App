//
//  EzyCook_Recipe_AppApp.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-11.
//

import SwiftUI

@main
struct EzyCook_Recipe_AppApp: App {
    
    @StateObject private var userVM = UserViewModel()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //SplashScreenView()
            //AddIngredientsView()
            //RecipeListView()
            //MyRecipesView()
            SignInView()
           // ResetPasswordView()
           // OTPView()
          //  ForgotPasswordView()
                .environmentObject(UserViewModel())
        }
    }
}

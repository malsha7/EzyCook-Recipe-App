//
//  EzyCook_Recipe_AppApp.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-11.
//

import SwiftUI
import UserNotifications


@main
struct EzyCook_Recipe_AppApp: App {
    
    
    @StateObject private var userVM = UserViewModel()
    @StateObject var vm = RecipeViewModel()
    @StateObject private var calendarManager = CalendarManager.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            //SplashScreenView()
            //AddIngredientsView()
            //RecipeListView()
            //MyRecipesView()
            MainView()
           // SignInView()
        //   SignUpView()
           // ResetPasswordView()
           // OTPView()
          //  ForgotPasswordView()
                .environmentObject(UserViewModel())
                .environmentObject(RecipeViewModel())
                .environmentObject(calendarManager)
                .onAppear {
                    calendarManager.requestNotificationPermission() 
                }
        }
    }
}

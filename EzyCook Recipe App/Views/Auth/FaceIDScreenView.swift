//
//  FaceIDScreenView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-20.
//

import SwiftUI
import LocalAuthentication
import Security


struct FaceIDScreenView: View {
    
    @State private var isAuthenticating = false
    @State private var authenticationError: String?
    @State private var showingError = false
    @State private var animationScale: CGFloat = 1.0
    @State private var navigateToHome = false
    @State private var showSuccessAlert = false
    @State private var scanningAnimation = false
    @State private var selectedTab: Int = 0
    
    @EnvironmentObject var userVM: UserViewModel
    
    private var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    FaceIDScreenView()
}

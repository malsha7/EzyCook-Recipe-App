//
//  ProfileView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-16.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var phoneNumber: String = ""
    @State private var profileImage: UIImage?
    
    // validation states
    @State private var validationErrors: [String: String] = [:]
    @State private var showSuccessAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileView()
}

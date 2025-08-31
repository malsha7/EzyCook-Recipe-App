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
    @State private var selectedImage: UIImage? = nil
    var initialUsername: String? = nil
    var initialEmail: String? = nil
    // validation states
    @State private var validationErrors: [String: String] = [:]
    @State private var showSuccessAlert = false
    @StateObject private var userVM = UserViewModel()
   
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            
            // top navigation row
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.appBlue)
                        Text("Back")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
                
                Text("My Profile")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
                    .frame(width: 60) // balance the back button
            }
            
            // divider
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // profile image picker
            ImagePicker(selectedImage: $profileImage,
            imageSize: 100)
                            .onChange(of: profileImage) { newImage in
                                if let image = newImage {
                                    print(" ProfileView: profileImage binding updated - Size: \(image.size)")
                                    print(" ProfileView: Image dimensions: \(image.size.width) x \(image.size.height)")
                                    print(" ProfileView: Image scale: \(image.scale)")
                                } else {
                                    print(" ProfileView: profileImage binding cleared")
                                }
                            }
           
            VStack(spacing: 20) {
                
                CustomTextField(
                    title: "Name",
                    placeholder: "Enter Name",
                    text: $name,
                    keyboardType: .default,
                    autocapitalization: .words,
                    errorMessage: validationErrors["name"]
                )
                
                CustomTextField(
                    title: "Email",
                    placeholder: "Enter Email",
                    text: $email,
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    errorMessage: validationErrors["email"]
                )
                
                CustomTextField(
                    title: "Username",
                    placeholder: "Enter Username",
                    text: $username,
                    keyboardType: .default,
                    autocapitalization: .never,
                    errorMessage: validationErrors["username"]
                )
                
                CustomTextField(
                    title: "Phone Number",
                    placeholder: "Enter Phone Number",
                    text: $phoneNumber,
                    keyboardType: .phonePad,
                    autocapitalization: .never,
                    errorMessage: validationErrors["phoneNumber"]
                )
            }
            
            Spacer()
            
            // save button
            LiquidGlassButton(
                title: "Save",
                width: 227,
                height: 44,
                cornerRadius: 12,
                fontSize: 17,
                fontWeight: .medium
            ) {
                print("ProfileView: Current profileImage: \(profileImage != nil ? "present" : "nil")")
                                
                if let image = profileImage {
                    print(" ProfileView: Image to save - Size: \(image.size)")
                }
                saveProfile()
            }
            .padding(.bottom, 70)
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .alert("Success", isPresented: $showSuccessAlert) {
            Button("OK") { }
        } message: {
            Text("Profile saved successfully!")
        }
        .onAppear {
            loadProfile()
        }
        .onReceive(userVM.$profile) { profile in
            handleProfileLoaded(profile: profile)
        }
    }
    
    // load profile Data
    private func loadProfile() {
        print("\nProfileView: Starting loadProfile")
        
        if let initialEmail = initialEmail {
            email = initialEmail
            print("Set initial email: \(initialEmail)")
        }
        
        if let initialUsername = initialUsername {
            username = initialUsername
            print(" Set initial username: \(initialUsername)")
        }
        
        print(" Fetching profile from database")
        userVM.getProfile()
    }
    
    private func handleProfileLoaded(profile: UserProfile?) {
        guard let profile = profile else { return }
        
        print(" Profile loaded from database")
        
      
        self.email = profile.email
        self.username = profile.username ?? ""
        self.name = profile.name ?? ""
        self.phoneNumber = profile.phoneNumber ?? ""
        
     
        if let imageUrl = profile.profileImage, !imageUrl.isEmpty {
            print(" Loading existing image from: \(imageUrl)")
            loadProfileImage(from: imageUrl)
        } else {
            print(" No existing profile image")
            self.profileImage = nil
        }
    }
    
    private func loadProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            print(" Invalid image URL: \(urlString)")
            return
        }
        
        print(" Starting image download")
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                if let httpResponse = response as? HTTPURLResponse {
                    print(" Image response status: \(httpResponse.statusCode)")
                    
                    guard httpResponse.statusCode == 200 else {
                        print(" Image download failed with status: \(httpResponse.statusCode)")
                        return
                    }
                }
                
                guard let image = UIImage(data: data) else {
                    print(" Invalid image data received")
                    return
                }
                
                await MainActor.run {
                    self.profileImage = image
                    print(" Profile image loaded successfully")
                }
                
            } catch {
                print(" Error loading image: \(error.localizedDescription)")
                await MainActor.run {
                    // self.profileImage = UIImage(systemName: "person.circle")
                }
            }
        }
    }
    
    //save profile function
    private func saveProfile() {
        // clear previous errors
        validationErrors.removeAll()
        
        // validate the all fields
        let errors = ValidationHelper.validateAllFields(
            name: name,
            email: email,
            username: username,
            phoneNumber: phoneNumber
        )
        
        if !errors.isEmpty {
            validationErrors = errors
            return
        }
        
        // save to UserDefaults ()
        UserDefaults.standard.set(name.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "profile_name")
        UserDefaults.standard.set(email.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "profile_email")
        UserDefaults.standard.set(username.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "profile_username")
        UserDefaults.standard.set(phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines), forKey: "profile_phone")
        
        // save profile image
        if let image = profileImage,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "profile_image")
        }
        
        print("Profile saved successfully!")
        print("Name: \(name.trimmingCharacters(in: .whitespacesAndNewlines))")
        print("Email: \(email.trimmingCharacters(in: .whitespacesAndNewlines))")
        print("Username: \(username.trimmingCharacters(in: .whitespacesAndNewlines))")
        print("Phone: \(phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines))")
        
        // success alert
        showSuccessAlert = true
    }
}

#Preview {
    ProfileView()
}

//
//  SettingsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-18.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userVM: UserViewModel
    @State private var internalSelectedTab = 4
    var selectedTab: Binding<Int>?
    @State private var showingLogoutAlert = false
    //@Binding var selectedTab: Int
    @AppStorage("notificationsEnabled") private var notificationsEnabled: Bool = true
    
    private var currentSelectedTab: Binding<Int> {
    selectedTab ?? $internalSelectedTab
    }

    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.sfProMedium(size: 16))
                                Text("Back")
                                    .font(.sfProRegular(size: 17))
                            }
                            .foregroundColor(.appBlue)
                        }
                        
                        Spacer()
                        
                        Text("Settings")
                            .font(.sfProBold(size: 16))
                            .foregroundColor(.appWhite)
                        
                        Spacer()
                        
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                                .font(.sfProMedium(size: 16))
                            Text("Back")
                                .font(.sfProRegular(size: 17))
                        }
                        .opacity(0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.appBlack)
                    
                    Rectangle()
                        .fill(Color.appWhite.opacity(0.1))
                        .frame(height: 0.5)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                    
                            VStack(spacing: 0) {
                                NavigationLink(destination: ProfileView().navigationBarBackButtonHidden(true)) {
                                    SettingsRow(
                                        icon: "square.and.pencil",
                                        title: "Edit Profile",
                                        showChevron: true
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: ForgotPasswordView()) {
                                    SettingsRow(
                                        icon: "key",
                                        title: "Password Manager",
                                        showChevron: true
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                SettingsRowWithToggle(
                                    icon: "bell",
                                    title: "Notifications",
                                    isToggled: $notificationsEnabled
                                )
                                .onChange(of: notificationsEnabled) { newValue in
                                            if newValue {
                                            CalendarManager.shared.requestNotificationPermission()
                                            } else {
                                            UNUserNotificationCenter.current()
                                            .removeAllPendingNotificationRequests()
                                                                   }
                                                               }
                                
                                NavigationLink(destination: PrivacyPolicyView().navigationBarBackButtonHidden(true)) {
                                    SettingsRow(
                                        icon: "lock.shield",
                                        title: "Privacy Policy",
                                        showChevron: true
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                NavigationLink(destination: HelpGuidelinesView().navigationBarBackButtonHidden(true)) {
                                    SettingsRow(
                                        icon: "questionmark.circle",
                                        title: "Help & Guidelines",
                                        showChevron: true,
                                        isLast: true
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .background(Color.appBlack.opacity(0.4))
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            
                           
                            VStack(spacing: 0) {
                                Button(action: {
                                    showingLogoutAlert = true
                                }) {
                                    SettingsRow(
                                        icon: "rectangle.portrait.and.arrow.right",
                                        title: "Logout",
                                        showChevron: false,
                                        isLast: true,
                                        isLogout: true
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .background(Color.appBlack.opacity(0.4))
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            
                            Spacer(minLength: 120)
                        }
                        .padding(.top, 32)
                    }
                    
                    Spacer()
                    
                    BottomNavBar(selectedTab: currentSelectedTab)
                }
            }
        }
        .navigationBarHidden(true)
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                handleLogout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }

    }
    
    private func handleLogout() {
       
        userVM.logout()
        if selectedTab != nil {
           selectedTab!.wrappedValue = 0
        } else {
            internalSelectedTab = 0
        }
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let showChevron: Bool
    var isLast: Bool = false
    var isLogout: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                    .fill(Color.appWhite.opacity(0.1))
                    .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                    .font(.sfProMedium(size: 16))
                    .foregroundColor(.appWhite)
                }
                
                Text(title)
                    .font(.sfProRegular(size: 16))
                    .foregroundColor(.appWhite)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.sfProMedium(size: 12))
                        .foregroundColor(.appWhite.opacity(0.5))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appBlack.opacity(0.6))
            
            if !isLast {
                Rectangle()
                    .fill(Color.appWhite.opacity(0.1))
                    .frame(height: 0.5)
                    .padding(.leading, 64)
            }
        }
    }
}

struct SettingsRowWithToggle: View {
    let icon: String
    let title: String
    @Binding var isToggled: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                    .fill(Color.appWhite.opacity(0.1))
                    .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.sfProMedium(size: 16))
                        .foregroundColor(.appWhite)
                }
                
                Text(title)
                    .font(.sfProRegular(size: 16))
                    .foregroundColor(.appWhite)
                
                Spacer()
                
                Toggle("", isOn: $isToggled)
                    .toggleStyle(SwitchToggleStyle(tint: .appWhite.opacity(0.5)))
                    .scaleEffect(0.9)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appBlack.opacity(0.6))
            
            Rectangle()
                .fill(Color.appBlack.opacity(0.1))
                .frame(height: 0.5)
                .padding(.leading, 64)
        }
    }
}



//#Preview {
//    SettingsView()
//}

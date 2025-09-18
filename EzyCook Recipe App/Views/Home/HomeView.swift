//
//  HomeView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-21.
//

import SwiftUI

struct HomeView: View {
    
    @State private var searchText = ""
    @State private var showNotifications = false
    @State private var navigateToDetails = false
    @State private var navigateToTools = false
    
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var userVM: UserViewModel
    @EnvironmentObject var vm: RecipeViewModel
    
    @Binding var selectedTab: Int
    
    var body: some View {
        
        NavigationStack {
            ZStack {
                Color.appBlack.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 12)

                        HStack {
                            HStack(spacing: 10) {
                            if let url = userVM.profile?.displayImageURL {
                            AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                            } placeholder: {
                            ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .appWhite))
                            .frame(width: 36, height: 36)
                            }
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.appWhite.opacity(0.3), lineWidth: 1))
                                } else {
                                    Image(systemName: "person.circle.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.appWhite)
                                }

                                Text("Good Morning!")
                                    .font(.sfProRoundedMedium(size: 16))
                                    .foregroundColor(.appWhite)
                                    .shadow(color: .appBlack.opacity(0.3), radius: 2, x: 0, y: 2)

                                Spacer()

                                Button(action: { showNotifications = true }) {
                                    ZStack(alignment: .topTrailing) {
                                        Image(systemName: "bell")
                                        .foregroundColor(.appWhite)
                                        .font(.system(size: 24))

                                        let todayCount = calendarManager.reminders.filter {
                                            Calendar.current.isDateInToday($0.date)
                                        }.count

                                        if todayCount > 0 {
                                            Text("\(todayCount)")
                                                .font(.sfProRoundedBold(size: 12))
                                                .foregroundColor(.appWhite)
                                                .frame(width: 18, height: 18)
                                                .background(Color.appWhite.opacity(0.3))
                                                .clipShape(Circle())
                                                .offset(x: 10, y: -10)
                                        }
                                    }
                                }
                                .background(
                                    NavigationLink(
                                        "",
                                        destination: NotificationsView()
                                            .environmentObject(calendarManager),
                                        isActive: $showNotifications
                                    )
                                )
                            }
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 24)

                        HStack(spacing: 10) {
                            Text("Hi, \(userVM.profile?.username ?? "Guest")! What Taste you like Today!")
                                .font(.sfProRoundedRegular(size: 16))
                                .foregroundColor(.appWhite.opacity(0.8))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                        VStack(spacing: 6) {
                            HStack(spacing: 10) {
                                Image(systemName: "magnifyingglass")
                                .foregroundColor(.appWhite.opacity(0.8))
                                .frame(width: 18, height: 18)

                                ZStack(alignment: .leading) {
                                    if searchText.isEmpty {
                                        Text("Search Your Recipe")
                                        .foregroundColor(.appWhite.opacity(0.7))
                                        .font(.sfProRoundedRegular(size: 16))
                                    }
                                    TextField("", text: $searchText)
                                        .foregroundColor(.appWhite)
                                        .font(.sfProRoundedRegular(size: 16))
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 14)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                .fill(Color.appWhite.opacity(0.25))
                            )

                            if !vm.suggestedRecipes.isEmpty {
                                VStack(alignment: .leading, spacing: 0) {
                                    ForEach(vm.suggestedRecipes) { suggestion in
                                        Button(action: {
                                            searchText = suggestion.title
                                            vm.suggestedRecipes = []

                                            vm.getRecipeDetails(id: suggestion.id) {
                                                navigateToDetails = true
                                            }
                                        }) {
                                            Text(suggestion.title)
                                                .foregroundColor(.appWhite)
                                                .font(.sfProRoundedRegular(size: 15))
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 12)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }

                                        if suggestion.id != vm.suggestedRecipes.last?.id {
                                            Divider().background(Color.appWhite.opacity(0.2))
                                        }
                                    }
                                }
                                .background(Color.appWhite.opacity(0.25))
                                .cornerRadius(8)
                                .shadow(radius: 4)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        
                        Button(action: { print("Banner tapped") }) {
                            ZStack {
                                Image("banner_image")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 370, height: 120)
                                    .clipped()
                                    .cornerRadius(12)

                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.appBlack.opacity(0.35))
                                    .frame(width: 370, height: 120)

                                VStack(spacing: 16) {
                                    Text("Are Ready Explore Today Healthy \n Easy Recipes")
                                        .font(.sfProRoundedSemibold(size: 16))
                                        .foregroundColor(.appWhite)
                                        .multilineTextAlignment(.center)
                                        .shadow(color: .appBlack.opacity(0.7), radius: 3, x: 0, y: 2)

                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            navigateToTools = true
                                            print("Start Choose tapped") }) {
                                            Text("Start Choose")
                                                .font(.sfProRoundedMedium(size: 15))
                                                .foregroundColor(.appWhite)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 12)
                                                        .fill(Color.appWhite.opacity(0.25))
                                                        .overlay(
                                                            RoundedRectangle(cornerRadius: 12)
                                                            .stroke(Color.appWhite.opacity(0.4), lineWidth: 1)
                                                        )
                                                )
                                        }
                                    }
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)

                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Recommended For You!")
                                    .font(.sfProRoundedMedium(size: 16))
                                    .foregroundColor(.appWhite)
                                Spacer()
                            }
                            .padding(.horizontal, 16)

                            
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .appWhite))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 40)
                            }
                            else if let errorMessage = vm.errorMessage {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                                    .padding()
                            }
                            else if !vm.systemRecipes.isEmpty {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                    ForEach(vm.systemRecipes.prefix(4)) { recipe in
                                        RecipeCard(recipe: recipe)
                                            .onTapGesture {
                                                vm.selectedRecipe = recipe
                                                navigateToDetails = true
                                            }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            else {
                                Text("No recipes available")
                                    .foregroundColor(.appWhite.opacity(0.6))
                                    .padding(.vertical, 40)
                            }
                        }
                        .padding(.top, 20)

                        Spacer(minLength: 120)
                    }
                    .padding(.bottom, 80)
                }

                NavigationLink(
                    destination: vm.selectedRecipe.map { RecipeDetailsView(recipe: $0)
                    .navigationBarBackButtonHidden(true)
                    },
                    isActive: $navigateToDetails,
                    label: { EmptyView() }
                )
                
                NavigationLink(
                    destination: SelectToolsView(selectedTab: $selectedTab)
                    .navigationBarBackButtonHidden(false),
                    isActive: $navigateToTools,
                    label: { EmptyView() }
                )
                
                VStack {
                        Spacer()
                        BottomNavBar(selectedTab: $selectedTab)
                        .padding(.bottom, 20)
                                }
            }
            .onAppear { userVM.getProfile()
                if vm.systemRecipes.isEmpty {
                        vm.getAllRecipes()
                    }
            }
            .onChange(of: searchText) { newValue in
                if !newValue.isEmpty {
                    vm.suggestRecipes(query: newValue)
                } else {
                    vm.suggestedRecipes = []
                }
            }
        }
    }
            
}

//#Preview {
//    HomeView()
//}

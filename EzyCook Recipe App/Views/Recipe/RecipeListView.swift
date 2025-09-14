//
//  RecipeListView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import SwiftUI

struct RecipeListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedRecipe: Recipe?
    
    // parameters from previous screens
    let selectedTools: [String]
    let selectedMealTime: String
    let selectedIngredients: [String]
    
    @EnvironmentObject var vm: RecipeViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            
            // top navigation row
            HStack {
                Button(action: {
                    // back to previous screen
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
                
                Text("Recipe List")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    // filter or search action
                    print("Filter recipes")
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "line.3.horizontal.decrease")
                            .foregroundColor(.appBlue)
                        Text("Filter")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
            }
            
            // divider line
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
            // show selected criteria
            VStack(alignment: .leading, spacing: 8) {
                if !vm.selectedMealTime.isEmpty {
                    HStack {
                        Text("Meal Time:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedMealTime)
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                    }
                }
                
                if !vm.selectedTools.isEmpty {
                    HStack {
                        Text("Tools:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedTools.joined(separator: ", "))
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                    }
                }
                
                if !vm.selectedIngredients.isEmpty {
                    HStack {
                        Text("Ingredients:")
                            .font(.sfProRegular(size: 14))
                            .foregroundColor(.appWhite.opacity(0.7))
                        Text(selectedIngredients.joined(separator: ", "))
                            .font(.sfProMedium(size: 14))
                            .foregroundColor(.appBlue)
                            .lineLimit(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            
            // recipe cards
            ScrollView {
                VStack(spacing: 16) {
                    if vm.filteredRecipes.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "fork.knife")
                                .font(.system(size: 48))
                                .foregroundColor(.appWhite.opacity(0.5))
                            
                            Text("No recipes found")
                                .font(.sfProMedium(size: 18))
                                .foregroundColor(.appWhite)
                            
                            Text("Try adjusting your selections to find more recipes")
                                .font(.sfProRegular(size: 14))
                                .foregroundColor(.appWhite.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 40)
                    } else {
                        ForEach(vm.filteredRecipes) { recipe in
                            RecipeCardView(recipe: recipe) {
                                selectedRecipe = recipe
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .fullScreenCover(item: $selectedRecipe) { recipe in
            RecipeDetailsView(recipe: recipe)
        }
        
        .onAppear {
            if vm.filteredRecipes.isEmpty {
                vm.filterRecipes()
            }
        }
    }
}





//#Preview {
//    RecipeListView()
//}

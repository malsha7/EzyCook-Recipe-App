//
//  AddIngredientsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import SwiftUI

struct AddIngredientsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var ingredients: [String] = []
    @State private var currentIngredient: String = ""
    @State private var navigateToRecipes = false
    @State private var navigateBack = false
    @State private var showAlert = false
    
   // var selectedTools: [String] = []
  //  var selectedMealTime: String = ""
    
    @EnvironmentObject var vm: RecipeViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            // top navigation bar
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
                
                Text("Select Ingredients")
                    .font(.sfProBold(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    handleRecipesAction()
                }) {
                    Text("Recipes")
                        .foregroundColor(.appBlue)
                        .font(.sfProMedium(size: 16))
                }
            }
            
            // divider
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
          
            Text("Available Ingredients")
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    
                    // display added ingredients
                    ForEach(ingredients, id: \.self) { ingredient in
                        ingredientRowView(ingredient: ingredient)
                    }
                    
                   
                    // input ingredeints + add button
                    HStack(spacing: 8) {
                        inputFieldView
                        
                        addButtonView
                    }
                    
                }
                .padding(.top, 10)
            }
            
            Spacer()
            
           //button
            LiquidGlassButton(
                title: "View Recipes",
                icon:"chevron.right",
                width: 227,
                height: 44,
                cornerRadius: 12,
                fontSize: 17,
                fontWeight: .medium
            ) {
                handleRecipesAction()
            }
           Spacer()
                .frame(height: 60)
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .navigationDestination(isPresented: $navigateToRecipes) {
//                    RecipeListView(
//                        selectedTools: selectedTools,
//                        selectedMealTime: selectedMealTime,
//                        selectedIngredients: ingredients
//                    )
            
                }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Add Ingredients"),
                message: Text("Please add at least one ingredient to continue"),
                dismissButton: .default(Text("OK"))
                    
            )
        }
    }
    
    // helper view
    
    @ViewBuilder
    private func ingredientRowView(ingredient: String) -> some View {
        HStack {
            Text(ingredient)
                .foregroundColor(.appBlue)
                .font(.sfProMedium(size: 16))
            Spacer()
            Button(action: {
                withAnimation {
                    ingredients.removeAll { $0 == ingredient }
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.appBlue)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.appBlue.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appBlue, lineWidth: 1)
        )
    }
    
    private var inputFieldView: some View {
        HStack(spacing: 8) {
            Image(systemName: "basket.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.appWhite.opacity(0.7))
            
            TextField("Ingredients", text: $currentIngredient)
                .foregroundColor(.appWhite)
                .font(.sfProRegular(size: 16))
                .placeholder(when: currentIngredient.isEmpty) {
                    Text("Ingredients")
                        .foregroundColor(.appWhite.opacity(0.5))
                        .font(.sfProRegular(size: 16))
                }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.appWhite.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
        )
    }
    
    private var addButtonView: some View {
        Button(action: addIngredient) {
            HStack(spacing: 6) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text("Add")
                    .font(.sfProMedium(size: 14))
            }
            .foregroundColor(.appWhite.opacity(0.7))
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(Color.appWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
            )
        }
        .disabled(currentIngredient.trimmingCharacters(in: .whitespaces).isEmpty)
    }
    
    // helper functioin
    
    private func handleRecipesAction() {
        if ingredients.isEmpty {
            showAlert = true
        } else {
            print("Final Recipe Plan:")
            print("Tools: \(vm.selectedTools)")
            print("Meal Time: \(vm.selectedMealTime)")
            print("Ingredients: \(vm.selectedIngredients)")
            
            vm.selectedIngredients = ingredients
            
            vm.filterRecipes()
            
            
            navigateToRecipes = true
        }
    }
    
    private func addIngredient() {
        let trimmed = currentIngredient.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        
        ingredients.append(trimmed)
        currentIngredient = ""
    }
    
    
    
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    
}
#Preview {
    AddIngredientsView()
}

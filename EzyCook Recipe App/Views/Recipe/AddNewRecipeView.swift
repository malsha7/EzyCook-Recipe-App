//
//  AddNewRecipeView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-19.
//

import SwiftUI

struct AddNewRecipeView: View {
    
   
    @State private var recipeTitle: String = ""
    @State private var cookingSteps: String = ""
    
    @State private var ingredients: [Ingredient] = []
    @State private var currentIngredientName: String = ""
    @State private var currentIngredientQuantity: String = ""
    
    @State private var showImagePicker = false
    @State private var recipeImage: UIImage?
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = RecipeViewModel()

    var body: some View {
        VStack(spacing: 20) {
            navigationHeader
            divider
            contentScrollView
            Spacer()
            saveButton
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .sheet(isPresented: $showImagePicker) {
            ImagePicker1(image: $recipeImage)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        
        .onChange(of: vm.createdRecipe) { recipe in
            if recipe != nil {
                alertMessage = "Recipe saved successfully!"
                showAlert = true
                clearAllFields()
               // presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: vm.errorMessage) { error in
            if let error = error {
                alertMessage = error
                showAlert = true
            }
        }
    }
}

//subviews
extension AddNewRecipeView {
    private var navigationHeader: some View {
        HStack {
            backButton
            titleLabel
            addButton
        }
    }
    
    private var backButton: some View {
        Button(action: { presentationMode.wrappedValue.dismiss() }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.appBlue)
                Text("Back")
                    .foregroundColor(.appBlue)
                    .font(.sfProMedium(size: 16))
            }
        }
    }
    
    private var titleLabel: some View {
        Text("Add New Recipe")
            .font(.sfProBold(size: 16))
            .foregroundColor(.appWhite)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var addButton: some View {
        Button(action: handleAddButtonTap) {
            HStack(spacing: 4) {
                Image(systemName: "plus")
                    .foregroundColor(.appBlue)
                    .font(.system(size: 12))
                Text("Add")
                    .foregroundColor(.appBlue)
                    .font(.sfProMedium(size: 16))
            }
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.appWhite.opacity(0.25))
            .frame(height: 1)
    }
    
    private var contentScrollView: some View {
        ScrollView {
            VStack(spacing: 24) {
                titleSection
                imageSection
                ingredientsSection
                stepsSection
            }
            .padding(.bottom, 100)
        }
    }
    
    private var titleSection: some View {
        CustomTextField(
            title: "Add Title",
            placeholder: "Enter Recipe Title",
            text: $recipeTitle
        )
    }
    
    private var imageSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Image")
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            imageUploadButton
        }
    }
    
    private var imageUploadButton: some View {
        Button(action: { showImagePicker = true }) {
            HStack(spacing: 12) {
                imageIcon
                imageLabel
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color.appWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    @ViewBuilder
    private var imageIcon: some View {
        if let recipeImage = recipeImage {
            Image(uiImage: recipeImage)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .cornerRadius(8)
        } else {
            Image(systemName: "photo")
                .foregroundColor(.appWhite.opacity(0.3))
                .font(.system(size: 16))
        }
    }
    
    private var imageLabel: some View {
        Text(recipeImage == nil ? "Upload an image" : "Image selected")
            .font(.sfProRegular(size: 16))
            .foregroundColor(.appWhite.opacity(0.6))
    }
    
   
    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Ingredients")
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            ingredientsList
            ingredientInput
        }
    }
    
    private var ingredientsList: some View {
        ForEach(ingredients, id: \.name) { ingredient in
            IngredientRow(
                ingredient: ingredient,
                onRemove: { removeIngredient(ingredient) }
            )
        }
    }
    
   
    private var ingredientInput: some View {
        HStack(spacing: 8) {
            HStack {
                Image(systemName: "basket.fill")
                    .foregroundColor(.white.opacity(0.7))
                TextField("Name", text: $currentIngredientName)
                    .foregroundColor(.appWhite.opacity(0.5))
                    .font(.sfProRegular(size: 16))
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.appWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                 
                    .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
            )
            
            TextField("Quantity", text: $currentIngredientQuantity)
                .foregroundColor(.appWhite.opacity(0.5))
                .font(.sfProRegular(size: 16))
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color.appWhite.opacity(0.1))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
                )
            
            Button(action: addIngredient) {
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.appWhite.opacity(0.5))
                    .font(.system(size: 20))
            }
            .disabled(currentIngredientName.trimmingCharacters(in: .whitespaces).isEmpty ||
                      currentIngredientQuantity.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
    
    private var stepsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Add Steps")
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite)
                .frame(maxWidth: .infinity, alignment: .leading)
            ZStack(alignment: .topLeading) {
                TextEditor(text: $cookingSteps)
                    .foregroundColor(.appWhite)
                    .font(.sfProRegular(size: 16))
                    .frame(minHeight: 120)
                    .padding(12)
                    .background(Color.clear)
                    .scrollContentBackground(.hidden)
                if cookingSteps.isEmpty {
                    Text("1. Add your first cooking step\n2. Press enter for new steps\n3. Write detailed instructions")
                        .foregroundColor(.appWhite.opacity(0.5))
                        .font(.sfProRegular(size: 16))
                        .padding(.top, 20)
                        .padding(.leading, 16)
                        .allowsHitTesting(false)
                }
            }
            .background(Color.appWhite.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appWhite.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    private var saveButton: some View {
        LiquidGlassButton(
            title: "Save",
            width: 227,
            height: 44,
            cornerRadius: 12,
            fontSize: 17,
            fontWeight: .medium
        ) {
            handleSaveButtonTap()
        }
        .padding(.bottom, 70)
    }
}


struct IngredientRow: View {
    let ingredient: Ingredient
    let onRemove: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "basket.fill")
                .foregroundColor(.appBlue)
            Text("\(ingredient.name) - \(ingredient.quantity ?? "")")
                .foregroundColor(.appBlue)
                .font(.sfProMedium(size: 16))
            Spacer()
            Button(action: onRemove) {
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
}


extension AddNewRecipeView {
    private func handleAddButtonTap() {
        
        clearAllFields()
    }
    
    private func handleSaveButtonTap() {
        if recipeTitle.isEmpty || cookingSteps.isEmpty || ingredients.isEmpty {
            alertMessage = "Please fill in all fields: title, ingredients, and cooking steps."
            showAlert = true
            return
        }
        vm.createRecipe(
            title: recipeTitle,
            description: cookingSteps,
            ingredients: ingredients,
            mealTime: nil,
            servings: 1,
            image: recipeImage
        )
    }
    
    private func addIngredient() {
        let name = currentIngredientName.trimmingCharacters(in: .whitespacesAndNewlines)
        let qty = currentIngredientQuantity.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty, !qty.isEmpty else { return }
        let ingredient = Ingredient(name: name, quantity: qty)
        ingredients.append(ingredient)
        currentIngredientName = ""
        currentIngredientQuantity = ""
    }
    
    private func removeIngredient(_ ingredient: Ingredient) {
        withAnimation {
            ingredients.removeAll { $0.name == ingredient.name && $0.quantity == ingredient.quantity }
        }
    }
    
    
    private func clearAllFields() {
        recipeTitle = ""
        cookingSteps = ""
        ingredients = []
        currentIngredientName = ""
        currentIngredientQuantity = ""
        recipeImage = nil
    }
    
}


//imagePicker helper
struct ImagePicker1: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker1
        
        init(_ parent: ImagePicker1) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}


#Preview {
    AddNewRecipeView()
}

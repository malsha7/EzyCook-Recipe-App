//
//  SelectToolsView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-17.
//

import SwiftUI

struct SelectToolsView: View {
    
    @State private var selectedTools: [String] = []
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToMealTime = false
    @State private var showAlert = false
    
    @EnvironmentObject var vm : RecipeViewModel
    
    let availableTools = ["Microwave Oven", "Gas Cooker","Rice Cooker", "Hot Plate", "Air Fryer", "Hearth"]
    
    var body: some View {
        
        NavigationStack {
            VStack(spacing: 20) {
                
               
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
                    
                    Text("Select Cooking Tools")
                        .font(.sfProBold(size: 16))
                        .foregroundColor(.appWhite)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button(action: saveSelectedTools) {
                        Text("Next")
                            .foregroundColor(.appBlue)
                            .font(.sfProMedium(size: 16))
                    }
                }
                
                Rectangle()
                    .fill(Color.appWhite.opacity(0.25))
                    .frame(height: 1)
                
                Text("Available Cooking Equipments")
                    .font(.sfProRegular(size: 16))
                    .foregroundColor(.appWhite.opacity(0.7))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack(spacing: 12) {
                    ForEach(availableTools, id: \.self) { tool in
                        Button(action: {
                            toggleToolSelection(tool)
                        }) {
                            HStack {
                                Text(tool)
                                    .foregroundColor(selectedTools.contains(tool) ? .appBlue : .appWhite)
                                    .font(.sfProMedium(size: 16))
                                Spacer()
                                if selectedTools.contains(tool) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.appBlue)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 20)
                            .frame(maxWidth: .infinity)
                            .background(selectedTools.contains(tool) ? Color.appBlue.opacity(0.1) : Color.appWhite.opacity(0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedTools.contains(tool) ? Color.appBlue : Color.appWhite.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                }
                
                Spacer()
                
               
                                NavigationLink(
                                    destination: SelectMealTimeView(selectedTools: selectedTools)
                                        .environmentObject(vm),
                                    isActive: $navigateToMealTime
                                ) {
                                    EmptyView()
                                }
                                .navigationBarBackButtonHidden()
            }
            .padding()
            .background(Color.appBlack.ignoresSafeArea())
            .navigationBarHidden(true)
            .alert("Select Cooking Tools", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Please select at least one cooking tool to continue.")
            }
            
          
            
        }
    }
    
    
    private func toggleToolSelection(_ tool: String) {
        if selectedTools.contains(tool) {
            selectedTools.removeAll { $0 == tool }
        } else {
            selectedTools.append(tool)
        }
    }
    
    private func saveSelectedTools() {
        if selectedTools.isEmpty {
            showAlert = true
        } else {
            print("Selected tools: \(selectedTools)")
            
           
                   vm.selectedTools = selectedTools
            
           
                  vm.filterRecipes()

            
            
            navigateToMealTime = true
        }
    }
       
}


#Preview {
    SelectToolsView()
}

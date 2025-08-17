//
//  SelectMealTimeView.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-18.
//

import SwiftUI

struct SelectMealTimeView: View {
    @State private var selectedMealTime: String = ""
    var selectedTools: [String] = []
    
    let availableMealTimes = ["Breakfast", "Lunch", "Dinner", "Evening Snacks", "Special Occassions"]
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var navigateToNextView = false
    
    
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
                
                Text("Select Meal Time")
                    .font(.sfProMedium(size: 16))
                    .foregroundColor(.appWhite)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Button(action: {
                    if selectedMealTime.isEmpty {
                        showAlert = true
                    } else {
                        navigateToNextView = true
                    }
                }) {
                    Text("Next")
                        .foregroundColor(.appBlue)
                        .font(.sfProMedium(size: 16))
                }
            }
            
            // divider
            Rectangle()
                .fill(Color.appWhite.opacity(0.25))
                .frame(height: 1)
            
           
            Text("Select Meal Time")
                .font(.sfProRegular(size: 14))
                .foregroundColor(.appWhite.opacity(0.7))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // meal time buttons
            VStack(spacing: 12) {
                ForEach(availableMealTimes, id: \.self) { mealTime in
                    Button(action: {
                        selectedMealTime = mealTime
                    }) {
                        HStack {
                            Text(mealTime)
                                .foregroundColor(selectedMealTime == mealTime ? .appBlue : .appWhite)
                                .font(.sfProMedium(size: 16))
                            Spacer()
                            if selectedMealTime == mealTime {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.appBlue)
                            }
                        }
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .frame(maxWidth: .infinity)
                        .background(selectedMealTime == mealTime ? Color.appBlue.opacity(0.1) : Color.appWhite.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedMealTime == mealTime ? Color.appBlue : Color.appWhite.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
            
            Spacer()
                .frame(height: 170)
            
          
            VStack {
                Button(action: {
                    if selectedMealTime.isEmpty {
                        showAlert = true
                    } else {
                        navigateToNextView = true
                    }
                }) {
                    LiquidGlassButton(
                        title: "Next",
                        icon: "chevron.right",
                        width: 227,
                        height: 44,
                        cornerRadius: 12,
                        fontSize: 17,
                        fontWeight: .medium) {
                        
                    }
                }
            }
            
            Spacer()
           
        }
        .padding()
        .background(Color.appBlack.ignoresSafeArea())
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Selection Required"),
                  message: Text("Please select a meal time to continue"),
                  dismissButton: .default(Text("OK")))
        }
//        .background(
//            NavigationLink(
//                destination: AddIngredientsView(selectedTools: selectedTools, selectedMealTime: selectedMealTime),
//                isActive: $navigateToNextView
//            ) {
//                SelectToolsView()
//            }
//            .hidden()
//        )
    }
    
}

#Preview {
    SelectMealTimeView()
}

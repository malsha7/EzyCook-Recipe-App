//
//  CustomTextField.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-16.
//

import SwiftUI

struct CustomTextField: View {
    
    let title: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    var errorMessage: String? = nil
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite)
            
            TextField(placeholder, text: $text)
                .font(.sfProRegular(size: 16))
                .foregroundColor(.appWhite)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.appWhite.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(errorMessage != nil ? Color.red : Color.appWhite.opacity(0.2), lineWidth: 1)
                )
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.sfProRegular(size: 12))
                    .foregroundColor(.red)
                    .padding(.leading, 4)
            }
        }
    }
}

#Preview {
    @State var sampleText = ""
    
    return CustomTextField(
        title: "Sample Title",
        placeholder: "Enter text here...",
        text: $sampleText
    )
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.appBlack)

}

//
//  AuthTextField.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-19.
//

import SwiftUI

struct AuthTextField: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    @State private var showPassword: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.appWhite)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.sfProMedium(size: 12))
                        .foregroundColor(.appWhite.opacity(0.7))
                        .shadow(color: .appBlack.opacity(0.2), radius: 1, x: 0, y: 1)
                }
                
                if isSecure {
                    Group {
                        if showPassword {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    }
                    .foregroundColor(.appWhite)
                    .font(.sfProRegular(size: 15))
                } else {
                    TextField("", text: $text)
                        .foregroundColor(.appWhite)
                        .font(.sfProRegular(size: 15))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            
            if isSecure {
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye" : "eye_lock.fill")
                        .foregroundColor(.appWhite)
                        .frame(width: 18, height: 18)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: 350)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appWhite.opacity(0.25))
        )
    }
}

// AuthTextField using Custom Styling
struct AuthTextFieldStyled: View {
    let iconName: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var backgroundColor: Color = Color.appWhite.opacity(0.25)
    var textColor: Color = .appWhite
    var placeholderColor: Color = Color.appWhite.opacity(0.7)
    var iconColor: Color = .appWhite
    var cornerRadius: CGFloat = 12
    var maxWidth: CGFloat = 350
    var fontSize: CGFloat = 15
    var placeholderFontSize: CGFloat = 12
    var fontStyle: FontStyle = .regular
    var placeholderFontStyle: FontStyle = .medium
    
    @State private var showPassword: Bool = false
    
    enum FontStyle {
        case regular, medium, semibold, bold
        case roundedRegular, roundedMedium, roundedSemibold, roundedBold
        
        func font(size: CGFloat) -> Font {
            switch self {
            case .regular:
                return .sfProRegular(size: size)
            case .medium:
                return .sfProMedium(size: size)
            case .semibold:
                return .sfProSemibold(size: size)
            case .bold:
                return .sfProBold(size: size)
            case .roundedRegular:
                return .sfProRoundedRegular(size: size)
            case .roundedMedium:
                return .sfProRoundedMedium(size: size)
            case .roundedSemibold:
                return .sfProRoundedSemibold(size: size)
            case .roundedBold:
                return .sfProRoundedBold(size: size)
            }
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(iconColor)
            
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(placeholderFontStyle.font(size: placeholderFontSize))
                        .foregroundColor(placeholderColor)
                        .shadow(color: .appBlack.opacity(0.2), radius: 1, x: 0, y: 1)
                }
                
                if isSecure {
                    Group {
                        if showPassword {
                            TextField("", text: $text)
                        } else {
                            SecureField("", text: $text)
                        }
                    }
                    .foregroundColor(textColor)
                    .font(fontStyle.font(size: fontSize))
                } else {
                    TextField("", text: $text)
                        .foregroundColor(textColor)
                        .font(fontStyle.font(size: fontSize))
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            
            if isSecure {
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye" : "eye_lock")
                        .foregroundColor(iconColor)
                        .frame(width: 20, height: 20)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .frame(maxWidth: maxWidth)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
        )
    }
}

//  Auth Field Types
extension AuthTextField {
    // username
    static func username(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "username",
            placeholder: "Enter Your Username",
            text: text
        )
    }
    
    // email
    static func email(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "email",
            placeholder: "Enter Your Email",
            text: text
        )
    }
    
    // password
    static func password(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "password",
            placeholder: "Enter Your Password",
            text: text,
            isSecure: true
        )
    }
    
    // confirm password
    static func confirmPassword(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "password",
            placeholder: "Confirm Your Password",
            text: text,
            isSecure: true
        )
    }
    
    // name
    static func fullName(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "person",
            placeholder: "Enter Your Full Name",
            text: text
        )
    }
    
    // phone number
    static func phoneNumber(text: Binding<String>) -> AuthTextField {
        AuthTextField(
            iconName: "phone",
            placeholder: "Enter Your Phone Number",
            text: text
        )
    }
}

// themed variants
extension AuthTextFieldStyled {
    // light theme variant
    static func lightTheme(
        iconName: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> AuthTextFieldStyled {
        AuthTextFieldStyled(
            iconName: iconName,
            placeholder: placeholder,
            text: text,
            isSecure: isSecure,
            backgroundColor: Color.appBlack.opacity(0.1),
            textColor: .appBlack,
            placeholderColor: Color.appBlack.opacity(0.6),
            iconColor: .appBlack,
            fontStyle: .regular,
            placeholderFontStyle: .medium
        )
    }
    
    // blue theme variant
    static func blueAccent(
        iconName: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> AuthTextFieldStyled {
        AuthTextFieldStyled(
            iconName: iconName,
            placeholder: placeholder,
            text: text,
            isSecure: isSecure,
            backgroundColor: Color.appBlue.opacity(0.15),
            textColor: .appBlue,
            placeholderColor: Color.appBlue.opacity(0.7),
            iconColor: .appBlue,
            fontStyle: .medium,
            placeholderFontStyle: .medium
        )
    }
    
    // rounded font variant
    static func rounded(
        iconName: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
    ) -> AuthTextFieldStyled {
        AuthTextFieldStyled(
            iconName: iconName,
            placeholder: placeholder,
            text: text,
            isSecure: isSecure,
            fontStyle: .roundedRegular,
            placeholderFontStyle: .roundedMedium
        )
    }
}

// examples
struct AuthTextFieldExamples: View {
    @State private var username = ""
    @State private var password = ""
    @State private var email = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // using  static methods with custom fonts/colors
            AuthTextField.username(text: $username)
            AuthTextField.email(text: $email)
            AuthTextField.password(text: $password)
            AuthTextField.confirmPassword(text: $confirmPassword)
            AuthTextField.fullName(text: $fullName)
            
            // custom styled variants
            AuthTextFieldStyled.lightTheme(
                iconName: "key",
                placeholder: "Enter Recovery Code",
                text: $password
            )
            
            AuthTextFieldStyled.blueAccent(
                iconName: "phone",
                placeholder: "Phone Number",
                text: $username
            )
            
            AuthTextFieldStyled.rounded(
                iconName: "email",
                placeholder: "Email Address",
                text: $email
            )
            
            // fully custom configuration
            AuthTextFieldStyled(
                iconName: "person",
                placeholder: "Custom Field",
                text: $fullName,
                backgroundColor: Color.appBlue.opacity(0.2),
                textColor: .appWhite,
                placeholderColor: .appWhite.opacity(0.8),
                iconColor: .appWhite,
                cornerRadius: 16,
                fontSize: 16,
                fontStyle: .roundedSemibold,
                placeholderFontStyle: .roundedMedium
            )
        }
        .padding()
    }
}

//#Preview {
//    AuthTextField()
//}

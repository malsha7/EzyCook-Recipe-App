//
//  Fonts.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-12.
//

import Foundation
import UIKit
import SwiftUI

//UIKit Fonts
extension UIFont {
    // SF Pro Rounded
    static func sfProRoundedBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold).rounded()
    }
    
    static func sfProRoundedSemibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold).rounded()
    }
    
    static func sfProRoundedMedium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium).rounded()
    }
    
    static func sfProRoundedRegular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular).rounded()
    }
    
    // SF Pro
    static func sfProBold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static func sfProSemibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func sfProMedium(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func sfProRegular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
}

//SwiftUI Fonts
extension Font {
    // SF Pro Rounded
    static func sfProRoundedBold(size: CGFloat) -> Font {
        return .system(size: size, weight: .bold, design: .rounded)
    }
    
    static func sfProRoundedSemibold(size: CGFloat) -> Font {
        return .system(size: size, weight: .semibold, design: .rounded)
    }
    
    static func sfProRoundedMedium(size: CGFloat) -> Font {
        return .system(size: size, weight: .medium, design: .rounded)
    }
    
    static func sfProRoundedRegular(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular, design: .rounded)
    }
    
    // SF Pro
    static func sfProBold(size: CGFloat) -> Font {
        return .system(size: size, weight: .bold)
    }
    
    static func sfProSemibold(size: CGFloat) -> Font {
        return .system(size: size, weight: .semibold)
    }
    
    static func sfProMedium(size: CGFloat) -> Font {
        return .system(size: size, weight: .medium)
    }
    
    static func sfProRegular(size: CGFloat) -> Font {
        return .system(size: size, weight: .regular)
    }
}

//UIFont Rounded Extension
extension UIFont {
    func rounded() -> UIFont {
        guard let descriptor = fontDescriptor.withDesign(.rounded) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: pointSize)
    }
}



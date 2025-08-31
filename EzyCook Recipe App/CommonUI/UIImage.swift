//
//  UIImage.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-08-31.
//

import Foundation
import UIKit

extension UIImage {
    func resized(toMaxWidth maxWidth: CGFloat) -> UIImage? {
        let width = self.size.width
        let height = self.size.height
        
        guard width > maxWidth else { return self }
        
        let scale = maxWidth / width
        let newHeight = height * scale
        UIGraphicsBeginImageContext(CGSize(width: maxWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: maxWidth, height: newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}

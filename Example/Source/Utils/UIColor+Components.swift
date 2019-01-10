//
//  UIColor+Components.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import Foundation
import UIKit

extension UIColor {
    
    // Convinient properties to get float values from RGBA color components.
    var redValue: CGFloat { return CIColor(color: self).red }
    var greenValue: CGFloat { return CIColor(color: self).green }
    var blueValue: CGFloat { return CIColor(color: self).blue }
    var alphaValue: CGFloat { return CIColor(color: self).alpha }
    
    // Convinient initializer to create a new UIColor instance with Int component parameters.
    
    // swiftlint:disable identifier_name
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        self.init(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
    }
    // swiftlint:enable identifier_name
    
    convenience init?(hex: String?) {
        guard var string = hex?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased() else {
            return nil
        }
        
        if string.hasPrefix("#") {
            string.remove(at: string.startIndex)
        }
        
        guard string.count == 6 else {
            return nil
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: string).scanHexInt64(&rgbValue)
        
        self.init(r: Int((rgbValue & 0xFF0000) >> 16),
                  g: Int((rgbValue & 0x00FF00) >> 8),
                  b: Int(rgbValue & 0x0000FF))
    }
    
}

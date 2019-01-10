//
//  GradientColors.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

public struct GradientColors {
    
    public var start: UIColor
    public var end: UIColor
    
    public var middleColor: UIColor {
        return UIColor(red: (start.redValue + end.redValue) / 2,
                       green: (start.greenValue + end.greenValue) / 2,
                       blue: (start.blueValue + end.blueValue) / 2,
                       alpha: (start.alphaValue + end.alphaValue) / 2)
    }
    
}

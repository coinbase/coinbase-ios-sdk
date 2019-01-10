//
//  ThemeGradientView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class ThemeGradientView: GradientView {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        gradientColors = GradientColors(start: Colors.lightBlue, end: Colors.darkBlue)
    }
    
}

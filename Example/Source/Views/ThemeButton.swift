//
//  ThemeButton.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class ThemeButton: UIButton {
    
    @IBInspectable var color: UIColor = Colors.green
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = color
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        backgroundColor = color
        
        layer.cornerRadius = 4
        
        titleLabel?.font = UIFont(name: Fonts.medium, size: 15)
        setTitleColor(UIColor.white, for: .normal)
    }
    
}

//
//  RoundedImageView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class RoundedImageView: UIImageView {

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initialSetup()
    }
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.size.height / 2
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.5
    }
    
}

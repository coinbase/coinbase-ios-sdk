//
//  ThemeRefreshControll.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class ThemeRefreshControll: UIRefreshControl {
    
    // MARK: - Initializers
    
    override init() {
        super.init()
        
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialSetup()
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        backgroundColor = UIColor.clear
        tintColor = Colors.darkGray
    }
    
}

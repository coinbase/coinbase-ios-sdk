//
//  GradientView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class GradientView: UIView {
    
    // MARK: - Properties
    
    public var gradientColors: GradientColors? {
        didSet {
            backgroundColor = gradientColors?.middleColor
        }
    }
    
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Lifecycle Methods
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if gradientLayer == nil {
            addGradientLayer()
        }
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Private Methods
    
    private func addGradientLayer() {
        gradientLayer = CAGradientLayer()
        createGradientLayer()
        layer.insertSublayer(gradientLayer!, at: 0)
    }
    
    private func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        if let gradientColors = gradientColors {
            gradientLayer?.colors = [gradientColors.start.cgColor, gradientColors.end.cgColor]
        }
        gradientLayer?.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer?.endPoint = CGPoint(x: 0, y: 1)
    }
    
}

//
//  SquareWithCurve.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

class SquareWithCurve: UIView {
    
    var shapeColor = UIColor.white {
        didSet {
            shapeLayer.fillColor = shapeColor.cgColor
        }
    }
    
    private let shapeLayer = CAShapeLayer()
    private let curveCoeff: CGFloat = 0.15
    
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
        
        shapeLayer.path = squarePath().cgPath
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        backgroundColor? = UIColor.clear
        
        shapeLayer.path = squarePath().cgPath
        shapeLayer.fillColor = shapeColor.cgColor
        layer.insertSublayer(shapeLayer, at: 0)
    }
    
    private func squarePath() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0.0, y: 0.0))                                  // top-left
        path.addLine(to: CGPoint(x: 0.0, y: bounds.size.height))                // top-left to bottom-left
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))  // bottom-left to bottom-right
        path.addLine(to: CGPoint(x: bounds.size.width, y: 0.0))                 // bottom-right to top-right
        path.addQuadCurve(to: CGPoint(x: 0.0, y: 0.0),                          // top-right to top-left curve
                          controlPoint: CGPoint(x: bounds.width / 2, y: bounds.height * curveCoeff))
        
        return path
    }
    
}

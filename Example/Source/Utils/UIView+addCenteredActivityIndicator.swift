//
//  UIView+addCenteredActivityIndicator.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

extension UIView {
    
    func addCenteredActivityIndicator() -> UIActivityIndicatorView {
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.color = Colors.darkGray
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activity)
        NSLayoutConstraint.activate([
            activity.centerXAnchor.constraint(equalTo: centerXAnchor),
            activity.centerYAnchor.constraint(equalTo: centerYAnchor)])
        
        return activity
    }
    
}

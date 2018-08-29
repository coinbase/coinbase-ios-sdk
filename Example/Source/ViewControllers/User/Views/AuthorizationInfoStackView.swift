//
//  AuthorizationInfoStackView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class AuthorizationInfoStackView: UIStackView {

    @IBOutlet weak var scopesStackView: UIStackView!
    @IBOutlet weak var metaStackView: UIStackView!
    
    // MARK: - Public Methods
    
    public func setup(with info: AuthorizationInfo) {
        scopesStackView.removeAllArrangedSubviews()
        for scope in info.scopes {
            scopesStackView.addArrangedSubview(infoLabel(with: scope))
        }
        
        metaStackView.removeAllArrangedSubviews()
        for meta in info.oauthMeta {
            let string = "\(meta.key): \(meta.value)"
            metaStackView.addArrangedSubview(infoLabel(with: string))
        }
    }
    
    // MARK: - Private Methods
    
    private func infoLabel(with text: String) -> UILabel {
        let label = UILabel()
        
        label.text = text
        label.font = UIFont(name: Fonts.regular, size: 14)
        
        label.textColor = Colors.gray
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }
    
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { [weak self] (allSubviews, subview) -> [UIView] in
            self?.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap { $0.constraints })
        
        // Remove the views from self
        removedSubviews.forEach { $0.removeFromSuperview() }
    }
}

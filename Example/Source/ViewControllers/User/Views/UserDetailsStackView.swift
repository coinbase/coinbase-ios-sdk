//
//  UserDetailsStackView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class UserDetailsStackView: UIStackView {

    @IBOutlet weak var timeZoneLabel: UILabel!
    @IBOutlet weak var nativeCurrencyLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func setup(with user: User) {
        timeZoneLabel.text = user.timeZone
        nativeCurrencyLabel.text = user.nativeCurrency
        
        countryLabel.text = user.countryString
        createdAtLabel.text = user.createdAtString
    }
    
}

private extension User {
    
    var countryString: String? {
        guard let country = country else {
            return nil
        }
        
        var string = country.name
        
        if let code = country.code {
            string.append("(\(code))")
        }
        if let state = state {
            string.append(", \(state)")
        }
        
        return string
    }
    
    var createdAtString: String? {
        guard let createdAt = createdAt else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter.string(from: createdAt)
    }
    
}

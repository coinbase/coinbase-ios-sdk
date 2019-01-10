//
//  UserHeaderView.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class UserHeaderView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var avatarImageView: RoundedImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func setup(with user: User) {
        Utils.loadImage(from: user.avatarURL) { [weak self] avatarImage in
            self?.backgroundImageView.image = avatarImage
            self?.avatarImageView.image = avatarImage
        }
        
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
    
}

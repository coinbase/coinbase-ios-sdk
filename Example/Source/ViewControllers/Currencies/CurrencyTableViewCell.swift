//
//  CurrencyTableViewCell.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class CurrencyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.font = UIFont(name: Fonts.demiBold, size: 15)
        detailTextLabel?.font = UIFont(name: Fonts.regular, size: 13)
    }
    
    public func setup(with currency: CurrencyInfo) {
        textLabel?.text = currency.name
        detailTextLabel?.text = currency.id
    }
    
}

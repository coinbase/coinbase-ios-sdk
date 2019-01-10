//
//  SpotPricesTableViewCell.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class SpotPricesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    public func setup(with price: Price) {
        currencyLabel.text = price.base
        priceLabel.text = "\(price.amount) \(price.currency)"
    }
    
}

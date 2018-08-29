//
//  AccountTableViewCell.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class AccountTableViewCell: UITableViewCell {

    private enum CurrencyIconSuffixes: String {
        case BTC
        case BCH
        case ETH
        case LTC
        case USD
    }

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    public func setup(with account: Account) {
        iconImageView.image = iconForCurrency(with: account.currency?.code)
        
        nameLabel.text = account.name
        amountLabel.text = account.amountString
    }
    
    private func iconForCurrency(with code: String?) -> UIImage? {
        let iconSuffix = CurrencyIconSuffixes(rawValue: code ?? "") ?? .USD
        return UIImage(named: "icon_\(iconSuffix.rawValue)")
    }
    
}

private extension Account {
    
    var amountString: String? {
        guard let balance = balance else {
            return nil
        }
        switch type {
        case CurrencyType.fiat:
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale.current
            formatter.currencyCode = balance.currency
            guard let amount = Float(balance.amount) else {
                return nil
            }
            return formatter.string(for: amount)
        default:
            return "\(balance.amount) \(balance.currency)"
        }
    }
    
}

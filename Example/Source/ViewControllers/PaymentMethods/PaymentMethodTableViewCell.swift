//
//  PaymentMethodTableViewCell.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var primaryBuyIndicatorView: UIView!
    @IBOutlet weak var primarySellIndicatorView: UIView!
    @IBOutlet weak var allowBuyIndicatorView: UIView!
    @IBOutlet weak var allowSellIndicatorView: UIView!
    @IBOutlet weak var allowDepositIndicatorView: UIView!
    @IBOutlet weak var allowWithdrawIndicatorView: UIView!
    @IBOutlet weak var instantBuyIndicatorView: UIView!
    @IBOutlet weak var instantSellIndicatorView: UIView!
    @IBOutlet weak var paymentMethodName: UILabel!
    @IBOutlet weak var paymentMethodCurrency: UILabel!
    
    public func setup(with paymentMethod: PaymentMethod) {
        paymentMethodName.text = paymentMethod.name
        paymentMethodCurrency.text = paymentMethod.currency
        
        primaryBuyIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.primaryBuy)
        primarySellIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.primarySell)
        allowBuyIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.allowBuy)
        allowSellIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.allowSell)
        allowDepositIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.allowDeposit)
        allowWithdrawIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.allowWithdraw)
        instantBuyIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.instantBuy)
        instantSellIndicatorView.backgroundColor = indicatorColor(for: paymentMethod.instantSell)
    }
    
    private func indicatorColor(for isOn: Bool?) -> UIColor {
        return (isOn ?? false) ? Colors.lightGreen : Colors.lightRed
    }

}

//
//  TransactionTableViewCell.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var statusIndicatorView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Public Methods
    
    public func setup(with transaction: Transaction) {
        titleLabel.text = transaction.details?.title
        subtitleLabel.text = transaction.details?.subtitle
        amountLabel.text = transaction.amountString
        statusLabel.text = transaction.status
        
        if let amount = transaction.amount?.amount,
            let amountFloat = Float(amount), amountFloat > 0 {
            amountLabel.textColor = Colors.green
        } else {
            amountLabel.textColor = Colors.darkBlue
        }
        setupStatusIndicator(with: transaction.status)
    }
    
    // MARK: - Private Methods
    
    private func setupStatusIndicator(with status: String?) {
        switch status {
        case TransactionStatus.completed:
            statusIndicatorView.backgroundColor = Colors.lightGreen
        case TransactionStatus.canceled,
             TransactionStatus.expired,
             TransactionStatus.failed:
            statusIndicatorView.backgroundColor = Colors.lightRed
        default:
            statusIndicatorView.backgroundColor = Colors.yellow
        }
    }
    
}

private extension Transaction {
    
    var amountString: String? {
        guard let amount = amount else {
            return nil
        }
        return "\(amount.amount) \(amount.currency)"
    }
    
}

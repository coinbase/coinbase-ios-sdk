//
//  TradeExpandOption.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Expand options for Trade Resources:
///     [Buy](https://developers.coinbase.com/api/v2#buys),
///     [Sell](https://developers.coinbase.com/api/v2#sells),
///     [Deposit](https://developers.coinbase.com/api/v2#deposits),
///     [Withdrawal](https://developers.coinbase.com/api/v2#withdrawals)
///
/// - transaction: Expands `transaction` property.
/// - paymentMethod: Expands `paymentMethod` property.
/// - all: Expands all expandable properties.
///
/// **Online API Documentation**
///
/// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
///
public enum TradeExpandOption: String {
    /// Expands `transaction` property.
    case transaction
    /// Expands `paymentMethod` property.
    case paymentMethod = "payment_method"
    /// Expands all expandable properties.
    case all
}

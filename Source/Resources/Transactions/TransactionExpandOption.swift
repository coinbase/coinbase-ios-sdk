//
//  TransactionExpandOption.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Expand options for [Transaction Resource](https://developers.coinbase.com/api/v2#transactions)
///
/// - from: Expands `from` property.
/// - to: Expands `to` property.
/// - buy: Expands `buy` property.
/// - sell: Expands `sell` property.
/// - fialDeposit: Expands `fialDeposit` property.
/// - fiatWithdrawal: Expands `fiatWithdrawal` property.
/// - application: Expands `application` property.
/// - address: Expands `address` property.
/// - all: Expands all expandable properties.
///
/// **Online API Documentation**
///
/// [Transaction Resource](https://developers.coinbase.com/api/v2#transactions),
/// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
///
public enum TransactionExpandOption: String {
    /// Expands `from` property.
    case from
    /// Expands `to` property.
    case to
    /// Expands `buy` property.
    case buy
    /// Expands `sell` property.
    case sell
    /// Expands `fialDeposit` property.
    case fialDeposit = "fiat_deposit"
    /// Expands `fiatWithdrawal` property.
    case fiatWithdrawal = "fiat_withdrawal"
    /// Expands `application` property.
    case application
    /// Expands `address` property.
    case address
    /// Expands all expandable properties.
    case all
}

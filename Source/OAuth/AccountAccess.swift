//
//  AccountAccess.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Used to request different access to user’s wallets.
///
/// - all: Application will get access to all of user’s wallets.
/// - select: Allows user to pick the wallet among all of user’s wallets associated
///     with the application.
/// - selectFromCurrency: Allows user to pick the wallet among user’s wallets of a
///     specified currency and associated with the application.
///
/// **Online API Documentation**
///
/// [Account access](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions).
///
public enum AccountAccess {
    /// Access to all of user’s wallets.
    case all
    /// Allows user to pick the wallet among all of user’s wallets associated with the application.
    case select
    /// Allows user to pick the wallet among user’s wallets of a specified currency and associated with the application.
    case selectFromCurrency(_ : [String])
    
    internal var stringValue: String {
        switch self {
        case .all:
            return "all"
        case .select, .selectFromCurrency:
            return "select"
        }
    }
    
    internal var currency: String? {
        switch self {
        case .all, .select:
            return nil
        case .selectFromCurrency(let currency):
            return currency.joined(separator: ",")
        }
    }
    
}

//
//  RequestTransactionParameters.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Represents parameters passed with request to request money.
///
open class RequestTransactionParameters: TransactionParameters {
    
    /// Creates a new instance from given parameters.
    ///
    /// Type of the transaction - **request**.
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    /// - Parameters:
    ///   - to: A bitcoin address, bitcoin cash address, litecoin address, ethereum address, or an email of the recipient.
    ///   - amount: Amount to be sent.
    ///   - currency: Currency for the `amount`.
    ///   - description: Notes to be included in the email that the recipient receives.
    ///
    public init(to: String, amount: String, currency: String, description: String? = nil) {
        super.init(type: TransactionType.request, to: to, amount: amount, currency: currency, description: description)
    }
    
}

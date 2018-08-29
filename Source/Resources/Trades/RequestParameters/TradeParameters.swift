//
//  TradeParameters.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Parameters required to place trade order.
///
open class TradeParameters: DictionaryConvertible {

    /// Amount.
    public var amount: String
    /// Currency for the `amount`.
    public var currency: String
    
    /// If set to `false`, this order will not be immediately completed.
    /// Use the `commit` method to complete.
    ///
    /// - Note:
    /// If property is `nil` order will be placed with `commit: true`.
    ///
    public var commit: Bool?
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - amount: Amount.
    ///   - currency: Currency for the `amount`.
    ///   - commit: If set to `false`, this order will not be immediately completed.
    ///         Use the `commit` method to complete.
    ///
    ///     **Note**
    ///
    ///     If property is `nil` order will be placed with `commit: true`.
    ///
    public init(amount: String, currency: String, commit: Bool? = nil) {
        self.amount = amount
        self.currency = currency
        self.commit = commit
    }
    
    // MARK: - DictionaryConvertible Methods
    
    public var toDictionary: [String: Any] {
        var dictionary = [ParameterKeys.amount: amount,
                          ParameterKeys.currency: currency]
        if let commit = commit {
            dictionary[ParameterKeys.commit] = String(commit)
        }
        
        return dictionary
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let amount = "amount"
        static let currency = "currency"
        static let commit = "commit"
    }
    
}

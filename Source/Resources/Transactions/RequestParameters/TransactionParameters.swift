//
//  TransactionParameters.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents base parameters required to create transaction.
///
open class TransactionParameters: DictionaryConvertible {
    
    /// Type of the transaction.
    public let type: String
    /// A bitcoin address, bitcoin cash address, litecoin address, ethereum address, or an email of the recipient.
    public let to: String
    /// Amount to be sent.
    public let amount: String
    /// Currency for the `amount`.
    public let currency: String
    /// Notes to be included in the email that the recipient receives.
    public let description: String?
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - type: Type of the transaction.
    ///   - to: A bitcoin address, bitcoin cash address, litecoin address, ethereum address, or an email of the recipient.
    ///   - amount: Amount to be sent.
    ///   - currency: Currency for the `amount`.
    ///   - description: Notes to be included in the email that the recipient receives.
    ///
    public init(type: String, to: String, amount: String, currency: String, description: String? = nil) {
        self.type = type
        self.to = to
        self.amount = amount
        self.currency = currency
        self.description = description
    }
    
    // MARK: - DictionaryConvertible Methods
    
    public var toDictionary: [String: Any] {
        var dictionary = [ParameterKeys.type: type,
                          ParameterKeys.to: to,
                          ParameterKeys.amount: amount,
                          ParameterKeys.currency: currency]
        if let description = description {
            dictionary[ParameterKeys.description] = description
        }
        return dictionary
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let type = "type"
        static let to = "to"
        static let amount = "amount"
        static let currency = "currency"
        static let description = "description"
    }
    
}

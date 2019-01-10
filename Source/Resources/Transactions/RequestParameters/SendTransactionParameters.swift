//
//  SendTransactionParameters.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents parameters passed with request to send money.
///
open class SendTransactionParameters: TransactionParameters {
    
    /// Don’t send notification emails for small amounts (e.g. tips).
    public let skipNotifications: Bool?
    /// Transaction fee in BTC/ETH/LTC if you would like to pay it.
    ///
    /// Fees can be added as a string, such as `"0.0005"`.
    public let fee: String?
    /// **[Recommended]** A token to ensure [idempotence](http://en.wikipedia.org/wiki/Idempotence).
    ///
    /// - Note:
    ///     If a previous transaction with the same `idem` parameter already exists for this sender,
    ///     that previous transaction will be returned and a new one will not be created.
    ///
    ///     Max length 100 characters.
    ///
    public let idem: String?
    /// Whether this send is to another financial institution or exchange.
    ///
    /// - Important:
    ///     Required if this send is to an address and is valued at over USD$3000.
    ///
    public let toFinancialInstitiution: Bool?
    /// The website of the financial institution or exchange.
    ///
    /// - Important:
    ///     Required if `toFinancialInstitiution` is true.
    ///
    public let financialInstitutionWebsite: String?
    
    /// Creates a new instance from given parameters.
    ///
    /// Type of the transaction - **send**.
    ///
    /// **See also**
    ///
    ///    `TransactionType` constants.
    ///
    /// - Parameters:
    ///   - type: Type of the transaction.
    ///   - to: A bitcoin address, bitcoin cash address, litecoin address, ethereum address, or an email of the recipient.
    ///   - amount: Amount to be sent.
    ///   - currency: Currency for the `amount`.
    ///   - description: Notes to be included in the email that the recipient receives.
    ///   - skipNotifications: Don’t send notification emails for small amounts (e.g. tips).
    ///   - fee: Transaction fee in BTC/ETH/LTC if you would like to pay it.
    ///
    ///       Fees can be added as a string, such as `"0.0005"`.
    ///
    ///   - idem: **[Recommended]** A token to ensure [idempotence](http://en.wikipedia.org/wiki/Idempotence).
    ///
    ///     **Note**
    ///
    ///       If a previous transaction with the same `idem` parameter already exists for this sender,
    ///       that previous transaction will be returned and a new one will not be created.
    ///
    ///     Max length 100 characters.
    ///
    ///   - toFinancialInstitiution: Whether this send is to another financial institution or exchange.
    ///
    ///     **Important**
    ///
    ///       Required if this send is to an address and is valued at over USD$3000.
    ///
    ///   - financialInstitutionWebsite: The website of the financial institution or exchange.
    ///
    ///     **Important**
    ///
    ///       Required if `toFinancialInstitiution` is true.
    ///
    public init(to: String,
                amount: String,
                currency: String,
                description: String? = nil,
                skipNotifications: Bool? = nil,
                fee: String? = nil,
                idem: String? = nil,
                toFinancialInstitiution: Bool? = nil,
                financialInstitutionWebsite: String? = nil) {
        self.skipNotifications = skipNotifications
        self.fee = fee
        self.idem = idem
        self.toFinancialInstitiution = toFinancialInstitiution
        self.financialInstitutionWebsite = financialInstitutionWebsite
        super.init(type: TransactionType.send, to: to, amount: amount, currency: currency, description: description)
    }
    
    // MARK: - DictionaryConvertible Methods
    
    override public var toDictionary: [String: Any] {
        var dictionary = super.toDictionary
        if let skipNotifications = skipNotifications {
            dictionary[ParameterKeys.skipNotifications] = skipNotifications
        }
        if let fee = fee {
            dictionary[ParameterKeys.fee] = fee
        }
        if let idem = idem {
            dictionary[ParameterKeys.idem] = idem
        }
        if let toFinancialInstitiution = toFinancialInstitiution {
            dictionary[ParameterKeys.toFinancialInstitiution] = toFinancialInstitiution
        }
        if let financialInstitutionWebsite = financialInstitutionWebsite {
            dictionary[ParameterKeys.financialInstitutionWebsite] = financialInstitutionWebsite
        }
        return dictionary
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let skipNotifications = "skip_notifications"
        static let fee = "fee"
        static let idem = "idem"
        static let toFinancialInstitiution = "to_financial_institution"
        static let financialInstitutionWebsite = "financial_institution_website"
    }
    
}

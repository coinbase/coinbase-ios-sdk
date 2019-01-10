//
//  MoneyHash.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents a money value with amount and currency.
///
open class MoneyHash: Decodable {

    /// Amount.
    ///
    /// - Note:
    ///     Amount is always returned as a string which you should be careful when parsing to have
    ///     correct decimal precision. Bitcoin, Bitcoin Cash, Litecoin and Ethereum values will have
    ///     8 decimal points and fiat currencies will have two.
    ///
    public let amount: String
    /// Currency codes conforming to the `ISO 4217` standard where possible.
    /// Currencies which have or had no representation in `ISO 4217` may use a custom code (e.g. `"BTC"`).
    public let currency: String

    private enum CodingKeys: String, CodingKey {
        case amount, currency
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        amount = try values.decode(String.self, forKey: .amount)
        currency = try values.decode(String.self, forKey: .currency)
    }
    
}

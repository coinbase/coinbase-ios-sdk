//
//  Price.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Represents a price of a crypto currency (`base`) in a fiat currency.
///
open class Price: Decodable {
    
    /// Crypto currency code.
    public let base: String
    /// The amount in fiat currency.
    public let amount: String
    /// Fiat currency code.
    ///
    /// Currency codes will conform to the ISO 4217 standard where possible.
    /// Currencies which have or had no representation in ISO 4217 may use a custom code in ISO format, ex. `"BTC"`, `"USD"`.
    ///
    public let currency: String
    
    private enum CodingKeys: String, CodingKey {
        case base, amount, currency
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        base = try values.decode(String.self, forKey: .base)
        amount = try values.decode(String.self, forKey: .amount)
        currency = try values.decode(String.self, forKey: .currency)
    }
    
}

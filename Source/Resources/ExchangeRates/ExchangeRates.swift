//
//  ExchangeRates.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Represents a exchange rates for specified currency.
///
open class ExchangeRates: Decodable {
    
    /// Base currency code.
    ///
    /// Currency codes will conform to the ISO 4217 standard where possible.
    /// Currencies which have or had no representation in ISO 4217 may use a custom code in ISO format, ex. `"BTC"`, `"USD"`.
    ///
    public let currency: String
    /// A dictionary of exchange rates where keys are currency codes and values are exchange rate for one unit of the base currency.
    public let rates: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case currency, rates
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        currency = try values.decode(String.self, forKey: .currency)
        rates = try values.decode([String: String].self, forKey: .rates)
    }
    
}

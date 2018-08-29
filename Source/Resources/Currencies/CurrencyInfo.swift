//
//  CurrencyInfo.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Represents a known currency.
///
open class CurrencyInfo: Decodable {
    
    /// Currency codes.
    ///
    /// Currency codes will conform to the ISO 4217 standard where possible.
    /// Currencies which have or had no representation in ISO 4217 may use a custom code in ISO format, ex. `"BTC"`, `"USD"`.
    ///
    public let id: String
    /// Human readable name for this currency (e.g Bitcoin).
    public let name: String
    /// Minimal amount available for transactions in this currency. Usually `0.01` for fiat currencies and `0.00000001` for crypto.
    public let minSize: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, minSize
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        minSize = try values.decode(String.self, forKey: .minSize)
    }

}

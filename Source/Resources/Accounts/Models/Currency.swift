//
//  CurrencyInfo.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
// 

/// Represents account's currency.
///
open class Currency: Decodable {
    
    /// Currency code.
    ///
    /// Currency codes will conform to the ISO 4217 standard where possible.
    /// Currencies which have or had no representation in ISO 4217 may use a custom code in ISO format, ex. `"BTC"`, `"USD"`.
    ///
    public let code: String
    /// Human readable name of this currency (e.g. 'Bitcoin').
    public let name: String?
    /// Color of this currency.
    public let color: String?
    /// Decimal precision.
    ///
    /// Bitcoin, Bitcoin Cash, Litecoin and Ethereum values will have 8 decimal points and fiat currencies will have two.
    public let exponent: Int?
    /// Currency type.
    ///
    /// See also: `CurrencyType` constants.
    public let type: String?
    /// A regular expression to check whether crypto currency address is valid.
    ///
    /// - Note:
    ///     This property is not present for fiat currencies.
    ///
    public let addressRegex: String?
    
    private enum CodingKeys: String, CodingKey {
        case code, name, color, exponent, type, addressRegex
    }
    
    public required init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self.code = try container.decode(String.self, forKey: .code)
            self.name = try container.decodeIfPresent(String.self, forKey: .name)
            self.color = try container.decodeIfPresent(String.self, forKey: .color)
            self.exponent = try container.decodeIfPresent(Int.self, forKey: .exponent)
            self.type = try container.decodeIfPresent(String.self, forKey: .type)
            self.addressRegex = try container.decodeIfPresent(String.self, forKey: .addressRegex)
        } else if let code = try? decoder.singleValueContainer().decode(String.self) {
            self.code = code
            self.name = nil
            self.color = nil
            self.exponent = nil
            self.type = nil
            self.addressRegex = nil
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Undefined resource type. Failed to decode."))
        }
    }
    
}

/// List of available currency types.
public struct CurrencyType {
    
    /// Crypto currency.
    public static let crypto = "crypto"
    /// Fiat currency.
    public static let fiat = "fiat"
    
}

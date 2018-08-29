//
//  Limits.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Information about buy, instant buy, sell and deposit limits.
///
open class PaymentMethodLimits: Decodable {
    
    /// Payment method limit type.
    public let type: String
    /// Payment method limit name.
    public let name: String
    /// An array of buy limits.
    public let buy: [PaymentMethodLimit]?
    /// An array of instant buy limits.
    public let instantBuy: [PaymentMethodLimit]?
    /// An array of sell limits.
    public let sell: [PaymentMethodLimit]?
    /// An array of deposit limits
    public let deposit: [PaymentMethodLimit]?
    
    private enum CodingKeys: String, CodingKey {
        case type, name, buy, instantBuy, sell, deposit
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decode(String.self, forKey: .type)
        name = try values.decode(String.self, forKey: .name)
        buy = try values.decodeIfPresent([PaymentMethodLimit].self, forKey: .buy)
        instantBuy = try values.decodeIfPresent([PaymentMethodLimit].self, forKey: .instantBuy)
        sell = try values.decodeIfPresent([PaymentMethodLimit].self, forKey: .sell)
        deposit = try values.decodeIfPresent([PaymentMethodLimit].self, forKey: .deposit)
    }

}

/// List of available payment method limits.
public struct LimitsType {
    
    public static let bank = "bank"
    public static let paypal = "paypal"
    public static let card = "card"
    public static let fiatAccount = "fiat_account"
    public static let xfers = "xfers"
    public static let wire = "wire"
    public static let intraBank = "intra_bank"
    
}

//
//  Sell.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Represents a sell of bitcoin, bitcoin cash, litecoin or ethereum using a payment method (either a bank or a fiat account).
/// Each committed sell also has an associated transaction.
///
open class Sell: Trade {
    
    /// Was this sell executed instantly?
    public let instant: Bool?
    /// Fiat amount with fees.
    public let total: MoneyHash?
    
    private enum CodingKeys: String, CodingKey {
        case instant, total
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        instant = try container.decodeIfPresent(Bool.self, forKey: .instant)
        total = try container.decodeIfPresent(MoneyHash.self, forKey: .total)
        
        try super.init(from: decoder)
    }
    
}

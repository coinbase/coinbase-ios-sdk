//
//  Deposit.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Represents a deposit of funds using a payment method (e.g. a bank).
/// Each committed deposit also has an associated transaction.
///
open class Deposit: Trade {
    
    /// Was this deposit executed instantly?
    public let instant: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case instant
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        instant = try container.decodeIfPresent(Bool.self, forKey: .instant)
        
        try super.init(from: decoder)
    }
    
}

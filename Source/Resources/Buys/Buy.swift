//
//  Buy.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Represents a purchase of bitcoin, bitcoin cash, litecoin or ethereum using a payment
/// method (either a bank or a fiat account). Each committed buy also has an associated transaction.
///
open class Buy: Trade {
    
    /// Was this buy executed instantly?
    public let instant: Bool?
    /// Fiat amount with fees.
    public let total: MoneyHash?
    /// Is buy requires completion step?
    public let requiresCompletionStep: Bool?
    /// Is it a first buy?
    public let isFirstBuy: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case instant, total, requiresCompletionStep, isFirstBuy
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        instant = try container.decodeIfPresent(Bool.self, forKey: .instant)
        total = try container.decodeIfPresent(MoneyHash.self, forKey: .total)
        requiresCompletionStep = try container.decodeIfPresent(Bool.self, forKey: .requiresCompletionStep)
        isFirstBuy = try container.decodeIfPresent(Bool.self, forKey: .isFirstBuy)
        
        try super.init(from: decoder)
    }
    
}

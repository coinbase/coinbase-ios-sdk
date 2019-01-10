//
//  PaymentMethodLimit.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Information about payment method limit.
///
open class PaymentMethodLimit: Decodable {
    
    /// Period in days.
    public let periodInDays: Int?
    /// Total money value.
    public let total: MoneyHash?
    /// Remaining money value.
    public let remaining: MoneyHash?
    /// Description.
    public let description: String?
    /// Label.
    public let label: String?
    /// Next requirement.
    public let nextRequirement: NextRequirement?
    
    private enum CodingKeys: String, CodingKey {
        case periodInDays, total, remaining, description, label, nextRequirement
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        periodInDays = try values.decodeIfPresent(Int.self, forKey: .periodInDays)
        total = try values.decodeIfPresent(MoneyHash.self, forKey: .total)
        remaining = try values.decodeIfPresent(MoneyHash.self, forKey: .remaining)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        label = try values.decodeIfPresent(String.self, forKey: .label)
        nextRequirement = try values.decodeIfPresent(NextRequirement.self, forKey: .nextRequirement)
    }

}

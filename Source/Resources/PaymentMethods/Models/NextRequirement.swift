//
//  NextRequirement.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Represents Next Requirement.
///
open class NextRequirement: Decodable {
    
    /// Next requirement type.
    ///
    /// **See also**
    ///
    ///   `NextRequirementType` constants.
    ///
    public let type: String?
    /// Volume money value.
    public let volume: MoneyHash?
    /// Remaining amout of money value.
    public let amountRemaining: MoneyHash?
    /// Time after starting.
    public let timeAfterStarting: Int?
    
    private enum CodingKeys: String, CodingKey {
        case type, volume, amountRemaining, timeAfterStarting
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try values.decodeIfPresent(String.self, forKey: .type)
        volume = try values.decodeIfPresent(MoneyHash.self, forKey: .volume)
        amountRemaining = try values.decodeIfPresent(MoneyHash.self, forKey: .amountRemaining)
        timeAfterStarting = try values.decodeIfPresent(Int.self, forKey: .timeAfterStarting)
    }

}

/// List of available next requirement types.
public struct NextRequirementType {
    
    public static let buyHistory = "buy_history"
    public static let identifyVerification = "identity_verification"
    public static let jumio = "jumio"
    public static let verifiedPhone = "verified_phone"
    
}

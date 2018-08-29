//
//  Trade.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Foundation

/// Base class for trade operation with funds (like buying, selling, creating deposit or withdrawal)
/// using a payment method. Each committed trade operation also has an associated transaction.
///
open class Trade: Decodable {
    
    /// Resource ID.
    public let id: String?
    /// Resource type.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String?
    /// Status of the trade. 
    ///
    /// **See also**
    ///
    ///   `TradeStatus` constants.
    ///
    public let status: String?
    /// Associated transaction (e.g. a bank, fiat account). Present when trade is committed.
    ///
    /// By default only `resource`, `id` and `resourcePath` will be present.
    /// To fetch expanded resource add `TradeExpandOption.transaction` to `expandOptions`.
    ///
    public let transaction: Transaction?
    /// Associated payment method (e.g. a bank, fiat account).
    ///
    /// By default only `resource`, `id` and `resourcePath` will be present.
    /// To fetch expanded resource add `TradeExpandOption.paymentMethod` to `expandOptions`.
    ///
    public let paymentMethod: PaymentMethod?
    /// User reference.
    public let userReference: String?
    /// Resource creation date.
    public let createdAt: Date?
    /// Resource update date.
    public let updatedAt: Date?
    /// Has this trade been committed?
    public let committed: Bool?
    /// When a trade isn’t executed instantly, it will receive a payout date for the time it will be executed.
    public let payoutAt: Date?
    /// Fee associated to this trade.
    public let fee: MoneyHash?
    /// Amount in bitcoin, bitcoin cash, litecoin or ethereum.
    public let amount: MoneyHash?
    /// Fiat amount without fees.
    public let subtotal: MoneyHash?
    /// Payment method fee.
    public let paymentMethodFee: MoneyHash?
    /// Hold days.
    public let holdDays: Int?
    /// Hold until.
    public let holdUntil: Date?
    
    private enum CodingKeys: String, CodingKey {
        case id, resource, resourcePath, status, transaction, paymentMethod, userReference, createdAt,
        updatedAt, committed, payoutAt, fee, amount, subtotal, paymentMethodFee, holdDays, holdUntil
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(String.self, forKey: .id)
        resource = try container.decode(String.self, forKey: .resource)
        resourcePath = try container.decodeIfPresent(String.self, forKey: .resourcePath)
        status = try container.decodeIfPresent(String.self, forKey: .status)
        transaction = try container.decodeIfPresent(Transaction.self, forKey: .transaction)
        paymentMethod = try container.decodeIfPresent(PaymentMethod.self, forKey: .paymentMethod)
        userReference = try container.decodeIfPresent(String.self, forKey: .userReference)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt)
        committed = try container.decodeIfPresent(Bool.self, forKey: .committed)
        payoutAt = try container.decodeIfPresent(Date.self, forKey: .payoutAt)
        fee = try container.decodeIfPresent(MoneyHash.self, forKey: .fee)
        amount = try container.decodeIfPresent(MoneyHash.self, forKey: .amount)
        subtotal = try container.decodeIfPresent(MoneyHash.self, forKey: .subtotal)
        paymentMethodFee = try container.decodeIfPresent(MoneyHash.self, forKey: .paymentMethodFee)
        holdDays = try container.decodeIfPresent(Int.self, forKey: .holdDays)
        holdUntil = try container.decodeIfPresent(Date.self, forKey: .holdUntil)
    }
    
}

/// List of available trade statuses.
///
/// - Important:
///     New `status` values might be added over time.
///
///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
public struct TradeStatus {
    
    public static let created = "created"
    public static let completed = "completed"
    public static let canceled = "canceled"
    
}

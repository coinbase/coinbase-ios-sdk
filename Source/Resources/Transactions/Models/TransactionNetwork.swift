//
//  Transaction.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Information about bitcoin, bitcoin cash, litecoin or ethereum network including network transaction
/// hash if transaction was on-blockchain.
///
/// - Note:
///     Only available for certain types of transactions.
///
open class TransactionNetwork: Decodable {

    /// Status.
    public let status: String
    /// Confirmations.
    public let confirmations: Int?
    /// Hash.
    public let hash: String?
    /// Transaction fee.
    public let transactionFee: MoneyHash?
    /// Transaction amount.
    public let transactionAmount: MoneyHash?
    
    private enum CodingKeys: String, CodingKey {
        case status, confirmations, hash, transactionFee, transactionAmount
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        status = try values.decode(String.self, forKey: .status)
        confirmations = try values.decodeIfPresent(Int.self, forKey: .confirmations)
        hash = try values.decodeIfPresent(String.self, forKey: .hash)
        transactionFee = try values.decodeIfPresent(MoneyHash.self, forKey: .transactionFee)
        transactionAmount = try values.decodeIfPresent(MoneyHash.self, forKey: .transactionAmount)
    }
    
}

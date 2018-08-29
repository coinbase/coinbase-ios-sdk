//
//  TransactionDetails.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Detailed information about the transaction.
///
open class TransactionDetails: Decodable {

    /// Title.
    public let title: String
    /// Subtitle.
    public let subtitle: String
    /// Name of payment method.
    public let paymentMethodName: String?

    private enum CodingKeys: String, CodingKey {
        case title, subtitle, paymentMethodName
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title = try values.decode(String.self, forKey: .title)
        subtitle = try values.decode(String.self, forKey: .subtitle)
        paymentMethodName = try values.decodeIfPresent(String.self, forKey: .paymentMethodName)
    }
    
}

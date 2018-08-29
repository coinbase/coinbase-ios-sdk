//
//  CryptoAddress.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Sending or receiving party of a transaction which is direct address of Bitcoin, Bitcoin Cash, Litecoin or Ethereum network.
///
open class CryptoAddress: Decodable {
    
    /// Resource type.
    public let resource: String
    /// Address.
    public let address: String?
    
    private enum CodingKeys: String, CodingKey {
        case resource, address
    }
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - resource: Resource type.
    ///   - address: Address.
    ///
    internal init(resource: String, address: String) {
        self.resource = resource
        self.address = address
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        resource = try values.decode(String.self, forKey: .resource)
        address = try values.decodeIfPresent(String.self, forKey: .address)
    }
    
}

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
    /// Address info.
    public let addressInfo: AddressInfo?
    
    private enum CodingKeys: String, CodingKey {
        case resource, addressInfo
    }
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - resource: Resource type.
    ///   - addressInfo: Address info.
    ///
    internal init(resource: String, addressInfo: AddressInfo) {
        self.resource = resource
        self.addressInfo = addressInfo
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        resource = try values.decode(String.self, forKey: .resource)
        addressInfo = try values.decodeIfPresent(AddressInfo.self, forKey: .addressInfo)
    }
    
}

/// Address info object for `to` objects in transactions list
open class AddressInfo: Decodable {

    /// The recipient address
    public let address: String

    /// The recipient optional destination tag
    public let destinationTag: String?

    private enum CodingKeys: String, CodingKey {
        case address, destinationTag
    }

    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - id: The address
    ///   - destinationTag: The destination tag
    internal init(address: String, destinationTag: String? = nil) {
        self.address = address
        self.destinationTag = destinationTag
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decode(String.self, forKey: .address)
        destinationTag = try values.decodeIfPresent(String.self, forKey: .destinationTag)
    }
}

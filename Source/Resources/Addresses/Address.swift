//
//  Address.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Foundation

/// Represents a bitcoin, bitcoin cash, litecoin or ethereum address for an account.
/// Account can have unlimited amount of addresses and they should be used only once.
///
open class Address: Decodable {
    
    /// Address ID.
    public let id: String
    /// Bitcoin, Bitcoin Cash, Litecoin or Ethereum address.
    public let address: String?
    /// User defined label for the address.
    public let name: String?
    /// Name of blockchain.
    public let network: String?
    /// Resource creation date.
    public let createdAt: Date?
    /// Resource update date.
    public let updatedAt: Date?
    /// Resource type. Constant: **"address"**.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String
    /// Crypto currency URI scheme.
    public let uriScheme: String?
    /// Warning title.
    public let warningTitle: String?
    /// Warning details.
    public let warningDetails: String?
    /// Legacy address.
    public let legacyAddress: String?
    /// Callback URL.
    public let callbackURL: String?
    /// Address info.
    public let addressInfo: AddressInfo?

    private enum CodingKeys: String, CodingKey {
        case id, address, name, network, createdAt, updatedAt, resource, resourcePath,
        uriScheme, warningTitle, warningDetails, legacyAddress, callbackURL = "callbackUrl",
        addressInfo
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        network = try values.decodeIfPresent(String.self, forKey: .network)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
        uriScheme = try values.decodeIfPresent(String.self, forKey: .uriScheme)
        warningTitle = try values.decodeIfPresent(String.self, forKey: .warningTitle)
        warningDetails = try values.decodeIfPresent(String.self, forKey: .warningDetails)
        legacyAddress = try values.decodeIfPresent(String.self, forKey: .legacyAddress)
        callbackURL = try values.decodeIfPresent(String.self, forKey: .callbackURL)
        addressInfo = try values.decodeIfPresent(AddressInfo.self, forKey: .addressInfo)
    }

}

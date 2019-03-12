//
//  TransactionParty.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// List of available transaction parties.
///
/// - email: An email address (e.g. not a registered Coinbase user).
/// - user: Registered Coinbase user.
/// - cryptoAddress: Direct address of Bitcoin, Bitcoin Cash, Litecoin or Ethereum network.
/// - account: An account (e.g. bitcoin, bitcoin cash, litecoin and ethereum wallets, fiat currency accounts, and vaults).
///
public enum TransactionParty: Decodable {
    
    /// An email address (e.g. not a registered Coinbase user).
    case email(EmailModel)
    /// Registered Coinbase user.
    case user(User)
    /// Direct address of Bitcoin, Bitcoin Cash, Litecoin or Ethereum network.
    case cryptoAddress(CryptoAddress)
    /// An account (e.g. bitcoin, bitcoin cash, litecoin and ethereum wallets, fiat currency accounts, and vaults).
    case account(Account)
    
    public init(from decoder: Decoder) throws {
        let resourceObject = try decoder.singleValueContainer().decode(ResourceObject.self)
        switch resourceObject.resource {
        case ResourceKeys.user:
            let user = try decoder.singleValueContainer().decode(User.self)
            self = .user(user)
        case ResourceKeys.email:
            let email = try decoder.singleValueContainer().decode(EmailModel.self)
            self = .email(email)
        case ResourceKeys.account:
            let account = try decoder.singleValueContainer().decode(Account.self)
            self = .account(account)
        case let field where field.hasSuffix(ResourceKeys.address) || field.hasSuffix(ResourceKeys.network):
            let cryptoAddress = try decoder.singleValueContainer().decode(CryptoAddress.self)
            self = .cryptoAddress(cryptoAddress)
        default:
            throw DecodingError.dataCorrupted(DecodingError.Context(
                codingPath: [],
                debugDescription: "Undefined resource type. Failed to decode.")
            )
        }
    }
    
    /// List of supported resource keys.
    private struct ResourceKeys {
        static let user = "user"
        static let email = "email"
        static let account = "account"
        static let address = "address"
        static let network = "network"
    }

}

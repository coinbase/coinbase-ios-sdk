//
//  Account.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
// 
import Foundation

/// Represents all of a user’s accounts, including bitcoin, bitcoin cash, litecoin and
/// ethereum wallets, fiat currency accounts, and vaults. This is represented in the
/// `type` property. See `AccountType` for more details.
///
/// - Note:
///     New types can be added over time.
///
///     User can only have one primary account and its type can only be `"wallet"`.
///
open class Account: Decodable {
    
    /// Resource ID.
    public let id: String
    /// User or system defined name.
	public let name: String?
    /// Whether this account is primary.
	public let primary: Bool?
    /// Type of this account.
    ///
    /// See also: `AccountType` constants.
	public let type: String?
    /// Account’s currency.
    public let currency: Currency?
    /// Balance of this account in it's currency.
	public let balance: MoneyHash?
    /// Resource creation date.
	public let createdAt: Date?
    /// Resource update date.
	public let updatedAt: Date?
    /// Resource type. Constant: **"account"**.
	public let resource: String
    /// Path for the location under `api.coinbase.com`.
	public let resourcePath: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, primary, type, currency, balance, createdAt, updatedAt, resource, resourcePath
    }
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - id: Resource ID.
    ///   - name: User or system defined name.
    ///   - primary: Whether this account is primary.
    ///   - type: Type of this account.
    ///   - currency: Account’s currency.
    ///   - balance: Balance of this account in it's currency.
    ///   - createdAt: Resource creation date.
    ///   - updatedAt: Resource update date.
    ///   - resourcePath: Path for the location under `api.coinbase.com`.
    ///
    internal init(id: String, name: String? = nil, primary: Bool? = nil, type: String? = nil, currency: Currency? = nil,
                  balance: MoneyHash? = nil, createdAt: Date? = nil, updatedAt: Date? = nil, resourcePath: String) {
        self.id = id
        self.name = name
        self.primary = primary
        self.type = type
        self.currency = currency
        self.balance = balance
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.resource = "account"
        self.resourcePath = resourcePath
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        currency = try values.decodeIfPresent(Currency.self, forKey: .currency)
        balance = try values.decodeIfPresent(MoneyHash.self, forKey: .balance)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
    }

}

/// List of available account types.
///
/// - Important:
///     New `type` values might be added over time.
///
///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
public struct AccountType {
    
    /// Wallet account. Only this account type can be set as primary.
    public static let wallet = "wallet"
    /// Fiat account.
    public static let fiat = "fiat"
    /// Vault account.
    public static let vault = "vault"
    /// Multisig vault account.
    public static let multisigVault = "multisig_vault"
    /// Multisig vault account.
    public static let multisig = "multisig"
    
}

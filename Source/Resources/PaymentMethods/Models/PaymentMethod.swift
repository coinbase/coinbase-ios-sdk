//
//  PaymentMethod.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 
import Foundation

/// Represents the different kinds of payment methods that can be used when buying and
/// selling bitcoin, bitcoin cash, litecoin or ethereum.
///
open class PaymentMethod: Decodable {

    /// Resource ID.
    public let id: String
    /// Payment method type.
    ///
    /// **See also**
    ///
    ///   `PaymentMethodType` constants.
    ///
    public let type: String?
    /// Payment method name.
    public let name: String?
    /// Payment method’s native currency.
    public let currency: String?
    /// Is primary buying method?
    public let primaryBuy: Bool?
    /// Is primary selling method?
    public let primarySell: Bool?
    /// Is buying allowed with this method?
    public let allowBuy: Bool?
    /// Is selling allowed with this method?
    public let allowSell: Bool?
    /// Is deposit allowed with this method?
    public let allowDeposit: Bool?
    /// Is withdraw allowed with this method?
    public let allowWithdraw: Bool?
    /// Does this method allow for instant buys?
    public let instantBuy: Bool?
    /// Does this method allow for instant sells?
    public let instantSell: Bool?
    /// Resource creation date.
    public let createdAt: Date?
    /// Resource update date.
    public let updatedAt: Date?
    /// Resource type. Constant: **"payment_method"**.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String
    /// Reference to the fiat account.
    ///
    /// By default only `resource`, `id` and `resourcePath` will be present.
    /// To fetch expanded resource add `PaymentMethodExpandOption.fiatAccount` to `expandOptions`.
    ///
    public let fiatAccount: Account?
    /// Information about buy, instant buy, sell and deposit limits.
    ///
    /// - Important:
    /// Will be presented if the user has obtained optional `Scope.Wallet.PaymentMethods.limits` permission.
    ///
    public let limits: PaymentMethodLimits?
    /// Is this method verified?
    public let verified: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id, type, name, currency, primaryBuy, primarySell, allowBuy, allowSell, allowDeposit, allowWithdraw,
        instantBuy, instantSell, createdAt, updatedAt, resource, resourcePath, fiatAccount, limits, verified
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        primaryBuy = try values.decodeIfPresent(Bool.self, forKey: .primaryBuy)
        primarySell = try values.decodeIfPresent(Bool.self, forKey: .primarySell)
        allowBuy = try values.decodeIfPresent(Bool.self, forKey: .allowBuy)
        allowSell = try values.decodeIfPresent(Bool.self, forKey: .allowSell)
        allowDeposit = try values.decodeIfPresent(Bool.self, forKey: .allowDeposit)
        allowWithdraw = try values.decodeIfPresent(Bool.self, forKey: .allowWithdraw)
        instantBuy = try values.decodeIfPresent(Bool.self, forKey: .instantBuy)
        instantSell = try values.decodeIfPresent(Bool.self, forKey: .instantSell)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
        fiatAccount = try values.decodeIfPresent(Account.self, forKey: .fiatAccount)
        limits = try values.decodeIfPresent(PaymentMethodLimits.self, forKey: .limits)
        verified = try values.decodeIfPresent(Bool.self, forKey: .verified)
    }
    
}

/// List of available payment method types.
///
/// - Important:
///     New `type` values might be added over time.
///
///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
public struct PaymentMethodType {
    
    /// Regular US bank account
    public static let achBankAccount = "ach_bank_account"
    /// European SEPA bank account
    public static let sepaBankAccount = "sepa_bank_account"
    /// iDeal bank account (Europe)
    public static let idealBankAccount = "ideal_bank_account"
    /// Fiat nominated Coinbase account
    public static let fiatAccount = "fiat_account"
    /// Bank wire (US only)
    public static let bankWire = "bank_wire"
    /// Credit card (can't be used for buying/selling)
    public static let creditCard = "credit_card"
    /// Secure3D verified payment card
    public static let secure3dCard = "secure3d_card"
    /// Canadian EFT bank account
    public static let eftBankAccount = "eft_bank_account"
    /// Interac Online for Canadian bank accounts
    public static let interac = "interac"
    
}

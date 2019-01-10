//
//  Transaction.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents an event on the account.
///
/// It can be either negative or positive on `amount` depending if it credited or debited funds on the account.
/// If there’s another party, the transaction will have either `to` or `from` property.
///
/// For certain types of transactions, also linked resources with `type` value as field will be included in the model
/// (example `buy` and `sell`).
///
/// All these fields are [expandable](https://developers.coinbase.com/api/v2#expanding-resources).
///
/// **See also**
///
///    `TransactionExpandOption` constants.
///
open class Transaction: Decodable {
    
    /// Resource ID.
    public let id: String
    /// Transaction type.
    ///
    /// - Important:
    ///     As transactions represent multiple objects, resources with new `type` values can and will be added over time.
    ///
    ///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    public let type: String?
    /// Status.
    ///
    /// - Important:
    ///     New `status` values might be added over time.
    ///
    ///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
    ///
    /// **See also**
    ///
    ///   `TransactionStatus` constants.
    ///
    public let status: String?
    /// Amount in bitcoin, bitcoin cash, litecoin or ethereum.
    public let amount: MoneyHash?
    /// Amount in user’s native currency.
    public let nativeAmount: MoneyHash?
    /// User defined description.
    public let description: String?
    /// Indicator if the transaction was instant exchanged (received into a bitcoin address for a fiat account).
    public let instantExchange: Bool?
    /// Resource creation date.
    public let createdAt: Date?
    /// Resource update date.
    public let updatedAt: Date?
    /// Resource type. Constant: **"transaction"**.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String
    /// Detailed information about the transaction.
    ///
    /// - Note:
    ///     As both types and statuses can change over time, it is recommended to use `details` field for
    ///     constructing human readable descriptions of transactions.
    ///
    public let details: TransactionDetails?
    /// Information about bitcoin, bitcoin cash, litecoin or ethereum network including network transaction hash
    /// if transaction was on-blockchain.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    public let network: TransactionNetwork?
    /// The receiving party of a debit transaction. Usually another resource but can also be another type like email.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.to` to `expandOptions`.
    ///
    public let to: TransactionParty?
    /// The originating party of a credit transaction. Usually another resource but can also be another type like
    /// bitcoin network.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.from` to `expandOptions`.
    ///
    public let from: TransactionParty?
    /// Associated [Buy](https://developers.coinbase.com/api/v2#buys) object.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.buy` to `expandOptions`.
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    public let buy: Buy?
    /// Associated [Sell](https://developers.coinbase.com/api/v2#sells) object.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.sell` to `expandOptions`.
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    public let sell: Sell?
    /// Associated [Deposit](https://developers.coinbase.com/api/v2#deposits) object.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.fiatDeposit` to `expandOptions`.
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    public let fiatDeposit: Deposit?
    /// Associated [Withdrawal](https://developers.coinbase.com/api/v2#withdrawals) object.
    ///
    /// - Note:
    ///     Only available for certain types of transactions.
    ///
    ///     By default only `resource`, `id` and `resourcePath` will be present.
    ///     To fetch expanded resource add `TransactionExpandOption.fiatWitdrawal` to `expandOptions`.
    ///
    /// **See also**
    ///
    ///   `TransactionType` constants.
    ///
    public let fiatWithdrawal: Withdrawal?
    /// Associated bitcoin, bitcoin cash, litecoin or ethereum address for received payment.
    ///
    /// By default only `resource`, `id` and `resourcePath` will be present.
    /// To fetch expanded resource add `TransactionExpandOption.address` to `expandOptions`.
    ///
    public let address: Address?
    /// Idempotence token.
    public let idem: String?
    /// Associated OAuth2 application.
    ///
    /// By default only `resource`, `id` and `resourcePath` will be present.
    /// To fetch expanded resource add `TransactionExpandOption.application` to `expandOptions`.
    ///
    public let application: ApplicationModel?
    
    private enum CodingKeys: String, CodingKey {
        case id, type, status, amount, nativeAmount, description, instantExchange, createdAt, updatedAt, resource,
        resourcePath, details, network, to, from, buy, sell, fiatDeposit, fiatWithdrawal, address, idem, application
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        amount = try values.decodeIfPresent(MoneyHash.self, forKey: .amount)
        nativeAmount = try values.decodeIfPresent(MoneyHash.self, forKey: .nativeAmount)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        instantExchange = try values.decodeIfPresent(Bool.self, forKey: .instantExchange)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        updatedAt = try values.decodeIfPresent(Date.self, forKey: .updatedAt)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
        details = try values.decodeIfPresent(TransactionDetails.self, forKey: .details)
        network = try values.decodeIfPresent(TransactionNetwork.self, forKey: .network)
        to = try values.decodeIfPresent(TransactionParty.self, forKey: .to)
        from = try values.decodeIfPresent(TransactionParty.self, forKey: .from)
        buy = try values.decodeIfPresent(Buy.self, forKey: .buy)
        sell = try values.decodeIfPresent(Sell.self, forKey: .sell)
        fiatDeposit = try values.decodeIfPresent(Deposit.self, forKey: .fiatDeposit)
        fiatWithdrawal = try values.decodeIfPresent(Withdrawal.self, forKey: .fiatWithdrawal)
        address = try values.decodeIfPresent(Address.self, forKey: .address)
        idem = try values.decodeIfPresent(String.self, forKey: .idem)
        application = try values.decodeIfPresent(ApplicationModel.self, forKey: .application)
    }
    
}

/// List of available transaction types.
///
/// - Important:
///     As transactions represent multiple objects, resources with new `type` values can and will be added over time.
///
///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
public struct TransactionType {
    
    /// Sent bitcoin/bitcoin cash/litecoin/ethereum to a bitcoin/bitcoin cash/litecoin/ethereum address or email.
    public static let send = "send"
    /// Requested bitcoin/bitcoin cash/litecoin/ethereum from a user or email.
    public static let request = "request"
    /// Transfered funds between two of a user’s accounts.
    public static let transfer = "transfer"
    /// Bought bitcoin, bitcoin cash, litecoin or ethereum.
    public static let buy = "buy"
    /// Sold bitcoin, bitcoin cash, litecoin or ethereum.
    public static let sell = "sell"
    /// Deposited funds into a fiat account from a financial institution.
    public static let fiatDeposit = "fiat_deposit"
    /// Withdrew funds from a fiat account.
    public static let fiatWithdrawal = "fiat_withdrawal"
    /// Deposited money into [GDAX](https://www.gdax.com).
    public static let exchangeDeposit = "exchange_deposit"
    /// Withdrew money from [GDAX](https://www.gdax.com).
    public static let exchangeWithdrawal = "exchange_withdrawal"
    /// Withdrew funds from a vault account.
    public static let vaultWithdrawal = "vault_withdrawal"
    
}

/// List of available transaction statuses.
///
/// - Important:
///     New `status` values might be added over time.
///
///     See more about [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
public struct TransactionStatus {
    
    /// Pending transactions (e.g. a send or a buy).
    public static let pending = "pending"
    /// Completed transactions (e.g. a send or a buy).
    public static let completed = "completed"
    /// Failed transactions (e.g. failed buy).
    public static let failed = "failed"
    /// Conditional transaction expired due to external factors.
    public static let expired = "expired"
    /// Transaction was canceled.
    public static let canceled = "canceled"
    /// Vault withdrawal is waiting for approval.
    public static let waitingForSignature = "waiting_for_signature"
    /// Vault withdrawal is waiting to be cleared.
    public static let waitingForClearing = "waiting_for_clearing"
    
}

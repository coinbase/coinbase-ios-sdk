//
//  TransactionResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// `TransactionResource` is a class which implements API methods for
/// [Transaction Resource](https://developers.coinbase.com/api/v2#transactions).
///
/// It can be either negative or positive on `amount` depending if it credited or debited funds on the account.
/// If there’s another party, the transaction will have either `to` or `from` property.
///
/// For certain types of transactions, also linked resources with `type` value as field will be included in the model
/// (example `buy` and `sell`).
///
/// All these fields are [expandable](https://developers.coinbase.com/api/v2#expanding-resources).
///
/// - Important:
///     As transactions represent multiple objects, resources with new type values can and
///     will be added over time. Also new status values might be added. See more about
///     [enumerable values](https://developers.coinbase.com/api/v2#enumerable-values).
///
///     Transactions statuses vary based on the type of the transaction. As both types and statuses can change
///     over time, we recommend that you use `details` property for constructing human readable descriptions of transactions.
///
/// **Online API Documentation**
///
/// [Transactions](https://developers.coinbase.com/api/v2#transactions),
/// [Expanding Resources](https://developers.coinbase.com/api/v2#expanding-resources),
/// [Enumerable values](https://developers.coinbase.com/api/v2#enumerable-values)
///
open class TransactionResource: BaseResource {
    
    /// Fetches a list of transactions for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List transactions](https://developers.coinbase.com/api/v2#list-transactions),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    public func list(accountID: String,
                     expandOptions: [TransactionExpandOption] = [],
                     page: PaginationParameters = PaginationParameters(),
                     completion: @escaping (_ result: Result<ResponseModel<[Transaction]>>) -> Void) {
        let endpoint = TransactionsAPI.list(accountID: accountID, expandOptions: expandOptions, page: page)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Fetches an individual transaction for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show a transaction](https://developers.coinbase.com/api/v2#show-a-transaction),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func transaction(accountID: String,
                            transactionID: String,
                            expandOptions: [TransactionExpandOption] = [],
                            completion: @escaping (_ result: Result<Transaction>) -> Void) {
        let endpoint = TransactionsAPI.transaction(accountID: accountID, transactionID: transactionID, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Send funds to a bitcoin address, bitcoin cash address, litecoin address, ethereum address, or email address.
    /// No transaction fees are required for off blockchain bitcoin transactions.
    ///
    /// It’s recommended to always supply a unique `idem` field for each transaction. This prevents you from sending
    /// the same transaction twice if there has been an unexpected network outage or other issue. You can provide `idem`
    /// as part of `parameters` model.
    ///
    /// If the user is able to buy bitcoin, they can send funds from their fiat account using instant exchange feature.
    /// Buy fees will be included in the created transaction and the recipient will receive the user defined amount.
    ///
    /// - Important:
    ///     This endpoint requires two factor authentication unless used with
    ///     `Scope.Wallet.Transactions.bypass2FASend` scope.
    ///
    ///     Call this method with `twoFactorAuthToken` set to `nil`, server will respond with status code `400`
    ///     and `message` indicating two factor authentication is required. After this, you can request `twoFactorAuthToken`
    ///     from user and send the same request again, which, if all data is correct, should succeed.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - twoFactorAuthToken: 2FA token to authorize this request.
    ///   - expandOptions: An array of fields to expand.
    ///   - parameters: Required parameters for [send money](https://developers.coinbase.com/api/v2#send-money) transaction.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.send`
    ///
    /// **Online API Documentation**
    ///
    /// [Send money](https://developers.coinbase.com/api/v2#send-money),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func send(accountID: String,
                     twoFactorAuthToken: String? = nil,
                     expandOptions: [TransactionExpandOption] = [],
                     parameters: SendTransactionParameters,
                     completion: @escaping (_ result: Result<Transaction>) -> Void) {
        let endpoint = TransactionsAPI.send(accountID: accountID,
                                            twoFactorAuthToken: twoFactorAuthToken,
                                            expandOptions: expandOptions,
                                            parameters: parameters)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Requests money from an email address.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - parameters: Required parameters for [request money](https://developers.coinbase.com/api/v2#request-money) transaction.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.request`
    ///
    /// **Online API Documentation**
    ///
    /// [Request money](https://developers.coinbase.com/api/v2#request-money),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func request(accountID: String,
                        expandOptions: [TransactionExpandOption] = [],
                        parameters: RequestTransactionParameters,
                        completion: @escaping (_ result: Result<Transaction>) -> Void) {
        let endpoint = TransactionsAPI.request(accountID: accountID, expandOptions: expandOptions, parameters: parameters)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Lets the recipient of a money request complete the request by sending money to the user who requested the money.
    ///
    /// - Important:
    ///     This can only be completed by the user to whom the request was made, *not* the user who sent the request.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.request`
    ///
    /// **Online API Documentation**
    ///
    /// [Complete request money](https://developers.coinbase.com/api/v2#complete-request-money),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func completeRequest(accountID: String,
                                transactionID: String,
                                expandOptions: [TransactionExpandOption] = [],
                                completion: @escaping (_ result: Result<Transaction>) -> Void) {
        let endpoint = TransactionsAPI.completeRequest(accountID: accountID, transactionID: transactionID, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Lets the user resend a money request.
    ///
    /// - Note:
    ///     This will notify recipient with a new email.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.request`
    ///
    /// **Online API Documentation**
    ///
    /// [Re-send request money](https://developers.coinbase.com/api/v2#re-send-request-money),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func resendRequest(accountID: String,
                              transactionID: String,
                              expandOptions: [TransactionExpandOption] = [],
                              completion: @escaping (_ result: Result<Transaction>) -> Void) {
        let endpoint = TransactionsAPI.resendRequest(accountID: accountID, transactionID: transactionID, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Lets a user cancel a money request.
    ///
    /// - Note:
    ///     Money requests can be canceled by the sender or the recipient.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.request`
    ///
    /// **Online API Documentation**
    ///
    /// [Cancel request money](https://developers.coinbase.com/api/v2#cancel-request-money)
    ///
    public func cancelRequest(accountID: String, transactionID: String, completion: @escaping (_ result: Result<EmptyData>) -> Void) {
        let endpoint = TransactionsAPI.cancelRequest(accountID: accountID, transactionID: transactionID)
        performRequest(for: endpoint, completion: completion)
    }
    
}

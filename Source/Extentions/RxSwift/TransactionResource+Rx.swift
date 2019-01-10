//
//  TransactionResource+Rx.swift
//  CoinbaseRx
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for TransactionResource

extension TransactionResource {
    
    /// Fetches a list of transactions for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_list(accountID: String,
                        expandOptions: [TransactionExpandOption] = [],
                        page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[Transaction]>> {
        return Single.create { single in
            self.list(accountID: accountID,
                      expandOptions: expandOptions,
                      page: page,
                      completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches an individual transaction for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_transaction(accountID: String,
                               transactionID: String,
                               expandOptions: [TransactionExpandOption] = []) -> Single<Transaction> {
        return Single.create { single in
            self.transaction(accountID: accountID,
                             transactionID: transactionID,
                             expandOptions: expandOptions,
                             completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_send(accountID: String,
                        twoFactorAuthToken: String? = nil,
                        expandOptions: [TransactionExpandOption] = [],
                        parameters: SendTransactionParameters) -> Single<Transaction> {
        return Single.create { single in
            self.send(accountID: accountID,
                      twoFactorAuthToken: twoFactorAuthToken,
                      expandOptions: expandOptions,
                      parameters: parameters,
                      completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }

    /// Requests money from an email address.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - parameters: Required parameters for [request money](https://developers.coinbase.com/api/v2#request-money) transaction.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_request(accountID: String,
                           expandOptions: [TransactionExpandOption] = [],
                           parameters: RequestTransactionParameters) -> Single<Transaction> {
        return Single.create { single in
            self.request(accountID: accountID,
                         expandOptions: expandOptions,
                         parameters: parameters,
                         completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_completeRequest(accountID: String,
                                   transactionID: String,
                                   expandOptions: [TransactionExpandOption] = []) -> Single<Transaction> {
        return Single.create { single in
            self.completeRequest(accountID: accountID,
                                 transactionID: transactionID,
                                 expandOptions: expandOptions,
                                 completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
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
    public func rx_resendRequest(accountID: String,
                                 transactionID: String,
                                 expandOptions: [TransactionExpandOption] = []) -> Single<Transaction> {
        return Single.create { single in
            self.resendRequest(accountID: accountID,
                               transactionID: transactionID,
                               expandOptions: expandOptions,
                               completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }

    /// Lets a user cancel a money request.
    ///
    /// - Note:
    ///     Money requests can be canceled by the sender or the recipient.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - transactionID: ID of a transaction associated to account specified by `accountID`.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Transactions.request`
    ///
    /// **Online API Documentation**
    ///
    /// [Cancel request money](https://developers.coinbase.com/api/v2#cancel-request-money)
    ///
    public func rx_cancelRequest(accountID: String, transactionID: String) -> Single<EmptyData> {
        return Single.create { single in
            self.cancelRequest(accountID: accountID, transactionID: transactionID, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }

}

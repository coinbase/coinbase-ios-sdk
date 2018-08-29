//
//  TradeResourceProtocol+Rx.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for TradeResourceProtocol

public extension TradeResourceProtocol {
    
    /// Fetches a list of Trade Resources for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    /// - Returns: `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - [Buy Resource](https://developers.coinbase.com/api/v2#buys):
    ///     - `Scope.Wallet.Buys.read`
    /// - [Sell Resource](https://developers.coinbase.com/api/v2#sells):
    ///     - `Scope.Wallet.Sells.read`
    /// - [Deposit Resource](https://developers.coinbase.com/api/v2#deposits):
    ///     - `Scope.Wallet.Deposits.read`
    /// - [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawals):
    ///     -`Scope.Wallet.Withdrawals.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    public func rx_list(accountID: String, expandOptions: [TradeExpandOption] = [],
                        page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[Model]>> {
        return Single.create { single in
            self.list(accountID: accountID, expandOptions: expandOptions, page: page, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches an individual Trade Resource for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - tradeID: ID of a trade associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///
    /// - Returns: `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - [Buy Resource](https://developers.coinbase.com/api/v2#buys):
    ///     - `Scope.Wallet.Buys.read`
    /// - [Sell Resource](https://developers.coinbase.com/api/v2#sells):
    ///     - `Scope.Wallet.Sells.read`
    /// - [Deposit Resource](https://developers.coinbase.com/api/v2#deposits):
    ///     - `Scope.Wallet.Deposits.read`
    /// - [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawals):
    ///     - `Scope.Wallet.Withdrawals.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func rx_show(accountID: String, tradeID: String, expandOptions: [TradeExpandOption] = []) -> Single<Model> {
        return Single.create { single in
            self.show(accountID: accountID, tradeID: tradeID, expandOptions: expandOptions, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Places order of specific Trade Resource type.
    ///
    /// - Note:
    /// it’s recommended to use the `commit: false` parameter to create an uncommitted order to show
    /// the confirmation for the user or get the final quote, and commit that with a separate request.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - parameters: Dictionary convertible model with required parameters for placing order.
    ///
    /// - Returns: `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - [Buy Resource](https://developers.coinbase.com/api/v2#buys):
    ///     - `Scope.Wallet.Buys.create`
    /// - [Sell Resource](https://developers.coinbase.com/api/v2#sells):
    ///     -`Scope.Wallet.Sells.create`
    /// - [Deposit Resource](https://developers.coinbase.com/api/v2#deposits):
    ///     - `Scope.Wallet.Deposits.create`
    /// - [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawals):
    ///     - `Scope.Wallet.Withdrawals.create`
    ///
    /// **Online API Documentation**
    ///
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func rx_placeOrder(accountID: String, expandOptions: [TradeExpandOption] = [], parameters: Parameters) -> Single<Model> {
        return Single.create { single in
            self.placeOrder(accountID: accountID, expandOptions: expandOptions, parameters: parameters, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Commits order that is created in `commit: false` state.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///
    /// - Returns: `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - [Buy Resource](https://developers.coinbase.com/api/v2#buys):
    ///     - `Scope.Wallet.Buys.create`
    /// - [Sell Resource](https://developers.coinbase.com/api/v2#sells):
    ///     - `Scope.Wallet.Sells.create`
    /// - [Deposit Resource](https://developers.coinbase.com/api/v2#deposits):
    ///     - `Scope.Wallet.Deposits.create`
    /// - [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawals):
    ///     - `Scope.Wallet.Withdrawals.create`
    ///
    /// **Online API Documentation**
    ///
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func rx_commit(accountID: String, tradeID: String, expandOptions: [TradeExpandOption] = []) -> Single<Model> {
        return Single.create { single in
            self.commit(accountID: accountID, tradeID: tradeID, expandOptions: expandOptions, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

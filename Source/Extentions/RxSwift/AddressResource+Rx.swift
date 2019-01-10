//
//  AddressResource+Rx.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for AddressResource

extension AddressResource {
    
    /// Fetches a list of addresses for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// - Important:
    ///     Addresses should be considered one time use only.
    ///     Please use `create(accountID:name:completion:)` to create new addresses.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.Addresses.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List addresses](https://developers.coinbase.com/api/v2#list-addresses),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination),
    /// [Create address](https://developers.coinbase.com/api/v2#create-address)
    ///
    public func rx_list(accountID: String, page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[Address]>> {
        return Single.create { single in
            self.list(accountID: accountID, page: page, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches an individual address for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - addressID: ID of an address associated to account specified by `accountID`.
    ///
    ///     A regular bitcoin, bitcoin cash, litecoin or ethereum address ID can be used in place of `addressID`
    ///     but the address has to be associated to the correct account.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// - Important:
    ///     Addresses should be considered one time use only.
    ///     Please use `create(accountID:name:completion:)` to create new addresses.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.Addresses.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show addresss](https://developers.coinbase.com/api/v2#list-addresses)
    ///
    public func rx_address(accountID: String, addressID: String) -> Single<Address> {
        return Single.create { single in
            self.address(accountID: accountID, addressID: addressID, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches a list of transactions that have been sent to a specific address.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - addressID: ID of an address associated to account specified by `accountID`.
    ///
    ///     A regular bitcoin, bitcoin cash, litecoin or ethereum address ID can be used in place of `addressID`
    ///     but the address has to be associated to the correct account.
    ///
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
    /// - `Scope.Wallet.Transactions.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List address’s transactions](https://developers.coinbase.com/api/v2#list-address39s-transactions),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func rx_transactions(accountID: String,
                                addressID: String,
                                expandOptions: [TransactionExpandOption] = [],
                                page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[Transaction]>> {
        return Single.create { single in
            self.transactions(accountID: accountID, addressID: addressID, expandOptions: expandOptions, page: page, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Creates a new address for an account.
    ///
    /// Addresses can be created for all account types. With fiat accounts,
    /// funds will be received with [Instant Exchange](https://www.coinbase.com/instant-exchange).
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - name: Address label.
    ///
    ///     As `name` parameter is optinal,
    ///     it’s possible to create new receive addresses for an account on-demand.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.Addresses.create`
    ///
    /// **Online API Documentation**
    ///
    /// [Create address](https://developers.coinbase.com/api/v2#create-address)
    ///
    public func rx_create(accountID: String, name: String) -> Single<Address> {
        return Single.create { single in
            self.create(accountID: accountID, name: name, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

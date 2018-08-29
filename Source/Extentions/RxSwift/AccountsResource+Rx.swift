//
//  AccountsResource+Rx.swift
//  CoinbaseRx
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for AccountResource

extension AccountResource {
    
    /// Fetches a list of current user’s accounts.
    ///
    /// - Important:
    ///     This metod returns **only one** account if user is authorized with `AccountAccessType.select` option.
    ///
    ///     To see the **full list** of accounts user should be authorized with option `AccountAccessType.all`.
    ///
    /// - Parameters:
    ///   - page: page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List accounts](https://developers.coinbase.com/api/v2#list-accounts),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    public func rx_list(page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[Account]>> {
        return Single.create { single in
            self.list(page: page, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches an individual current user’s account.
    ///
    /// To access the primary account for a given currency, a currency code (BTC or ETH)
    /// can be used instead of the account id.
    ///
    /// - Parameters:
    ///   - id: ID of an account or a currency code.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show an account](https://developers.coinbase.com/api/v2#show-an-account)
    ///
    public func rx_account(id: String) -> Single<Account> {
        return Single.create { single in
            self.account(id: id, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Promote an account as primary account.
    ///
    /// - Parameters:
    ///   - id: ID of an account.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Set account as primary](https://developers.coinbase.com/api/v2#set-account-as-primary)
    ///
    public func rx_setAccountPrimary(id: String) -> Single<Account> {
        return Single.create { single in
            self.setAccountPrimary(id: id, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Modifies user’s account.
    ///
    /// - Parameters:
    ///   - id: ID of an account.
    ///   - name: New account name.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Update account](https://developers.coinbase.com/api/v2#update-account)
    ///
    public func rx_updateAccount(id: String, name: String) -> Single<Account> {
        return Single.create { single in
            self.updateAccount(id: id, name: name, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    /// Removes user’s account.
    ///
    /// - Note:
    ///     In order to remove an account it can’t be:
    ///     - Primary account
    ///     - Account with non-zero balance
    ///     - Fiat account
    ///     - Vault with a pending withdrawal
    ///
    /// - Parameters:
    ///   - id: ID of an account.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.delete`
    ///
    /// **Online API Documentation**
    ///
    /// [Delete account](https://developers.coinbase.com/api/v2#delete-account)
    ///
    public func rx_deleteAccount(id: String) -> Single<EmptyData> {
        return Single.create { single in
            self.deleteAccount(id: id, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

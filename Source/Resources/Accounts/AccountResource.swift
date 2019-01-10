//
//  AccountsResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
// 

/// `AccountResource` is a class which implements API methods for
/// [Account resource](https://developers.coinbase.com/api/v2#accounts).
///
/// Account resource represents all of a user’s accounts, including bitcoin,
/// bitcoin cash, litecoin and ethereum wallets, fiat currency accounts, and vaults.
/// This is represented in the `type` property of `Account` model.
///
/// - Note:
///     New types can be added over time.
///
///     User can only have one primary account and its type can only be `"wallet"`.
///
/// **Online API Documentation**
///
/// [Account resource](https://developers.coinbase.com/api/v2#accounts).
///
open class AccountResource: BaseResource {
    
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
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
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
    public func list(page: PaginationParameters = PaginationParameters(), completion: @escaping (_ result: Result<ResponseModel<[Account]>>) -> Void) {
        let endpoint = AccountsAPI.list(page: page)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Fetches an individual current user’s account.
    ///
    /// To access the primary account for a given currency, a currency code (BTC or ETH)
    /// can be used instead of the account id.
    ///
    /// - Parameters:
    ///   - id: ID of an account or a currency code.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show an account](https://developers.coinbase.com/api/v2#show-an-account)
    ///
    public func account(id: String, completion: @escaping (_ result: Result<Account>) -> Void) {
        let endpoint = AccountsAPI.account(id: id)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Promote an account as primary account.
    ///
    /// - Parameters:
    ///   - id: ID of an account.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Set account as primary](https://developers.coinbase.com/api/v2#set-account-as-primary)
    ///
    public func setAccountPrimary(id: String, completion: @escaping (_ result: Result<Account>) -> Void) {
        let endpoint = AccountsAPI.setPrimary(id: id)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Modifies user’s account.
    ///
    /// - Parameters:
    ///   - id: ID of an account.
    ///   - name: New account name.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Update account](https://developers.coinbase.com/api/v2#update-account)
    ///
    public func updateAccount(id: String, name: String, completion: @escaping (_ result: Result<Account>) -> Void) {
        let endpoint = AccountsAPI.update(id: id, name: name)
        performRequest(for: endpoint, completion: completion)
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
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Accounts.delete`
    ///
    /// **Online API Documentation**
    ///
    /// [Delete account](https://developers.coinbase.com/api/v2#delete-account)
    ///
    public func deleteAccount(id: String, completion: @escaping (_ result: Result<EmptyData>) -> Void) {
        let endpoint = AccountsAPI.delete(id: id)
        performRequest(for: endpoint, completion: completion)
    }
    
}

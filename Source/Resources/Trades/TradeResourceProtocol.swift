//
//  TradeResourceProtocol.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Defines templates for all API requests for trade resources(`Buy`, `Sell`, `Deposit`, `Withdrawal`).
public protocol TradeResourceProtocol {
    
    /// Model for requested Trade resource.
    associatedtype Model: Decodable
    /// Request parameters required to perform `placeOrder` request.
    associatedtype Parameters: DictionaryConvertible
    
    /// Trade Resource type.
    var type: TradeResourceType { get }
    
    /// Fetches a list of Trade Resources for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
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
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    func list(accountID: String,
              expandOptions: [TradeExpandOption],
              page: PaginationParameters,
              completion: @escaping (_ result: Result<ResponseModel<[Model]>>) -> Void)
    
    /// Fetches an individual Trade Resource for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - tradeID: ID of a trade associated to account specified by `accountID`.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
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
    func show(accountID: String,
              tradeID: String,
              expandOptions: [TradeExpandOption],
              completion: @escaping (_ result: Result<Model>) -> Void)
    
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
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
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
    func placeOrder(accountID: String,
                    expandOptions: [TradeExpandOption],
                    parameters: Parameters,
                    completion: @escaping (_ result: Result<Model>) -> Void)
    
    /// Commits order that is created in `commit: false` state.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
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
    func commit(accountID: String,
                tradeID: String,
                expandOptions: [TradeExpandOption],
                completion: @escaping (_ result: Result<Model>) -> Void)
    
}

// MARK: - Default implementation for TradeResourceProtocol conforming to BaseResource

public extension TradeResourceProtocol where Self: BaseResource {
    
    public func list(accountID: String, expandOptions: [TradeExpandOption] = [], page: PaginationParameters = PaginationParameters(),
                     completion: @escaping (_ result: Result<ResponseModel<[Model]>>) -> Void) {
        let endpoint = TradesAPI.list(tradeType: type, accountID: accountID, expandOptions: expandOptions, page: page)
        performRequest(for: endpoint, completion: completion)
    }
    
    public func show(accountID: String, tradeID: String, expandOptions: [TradeExpandOption] = [], completion: @escaping (_ result: Result<Model>) -> Void) {
        let endpoint = TradesAPI.show(tradeType: type, accountID: accountID, tradeID: tradeID, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
    public func placeOrder(accountID: String, expandOptions: [TradeExpandOption] = [], parameters: Parameters, completion: @escaping (_ result: Result<Model>) -> Void) {
        let endpoint = TradesAPI.placeOrder(tradeType: type, accountID: accountID, expandOptions: expandOptions, parameters: parameters)
        performRequest(for: endpoint, completion: completion)
    }
    
    public func commit(accountID: String, tradeID: String, expandOptions: [TradeExpandOption] = [], completion: @escaping (_ result: Result<Model>) -> Void) {
        let endpoint = TradesAPI.commit(tradeType: type, accountID: accountID, tradeID: tradeID, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
}

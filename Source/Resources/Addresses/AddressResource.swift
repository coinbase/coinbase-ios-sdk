//
//  AddressResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `AddressResource` is a class which implements API methods for [Address Resource](https://developers.coinbase.com/api/v2#addresses).
///
/// Address Resource represents a bitcoin, bitcoin cash, litecoin or ethereum address for an account.
/// Account can have unlimited amount of addresses and they should be used only once.
///
/// **Online API Documentation**
///
/// [Addresses](https://developers.coinbase.com/api/v2#addresses)
///
open class AddressResource: BaseResource {
    
    /// Fetches a list of addresses for an account.
    ///
    /// - Parameters:
    ///   - accountID: ID of an account.
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
    /// - Important:
    ///     Addresses should be considered one time use only.
    ///     Please use `create(accountID:name:completion:)` to create new addresses.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Addresses.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List addresses](https://developers.coinbase.com/api/v2#list-addresses),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination),
    /// [Create address](https://developers.coinbase.com/api/v2#create-address)
    ///
    public func list(accountID: String,
                     page: PaginationParameters = PaginationParameters(),
                     completion: @escaping (_ result: Result<ResponseModel<[Address]>>) -> Void) {
        let endpoint = AddressesAPI.list(accountID: accountID, page: page)
        performRequest(for: endpoint, completion: completion)
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
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// - Important:
    ///     Addresses should be considered one time use only.
    ///     Please use `create(accountID:name:completion:)` to create new addresses.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Addresses.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show address](https://developers.coinbase.com/api/v2#list-addresses)
    ///
    public func address(accountID: String, addressID: String, completion: @escaping (_ result: Result<Address>) -> Void) {
        let endpoint = AddressesAPI.address(accountID: accountID, addressID: addressID)
        performRequest(for: endpoint, completion: completion)
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
    /// [List address’s transactions](https://developers.coinbase.com/api/v2#list-address39s-transactions),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func transactions(accountID: String,
                             addressID: String,
                             expandOptions: [TransactionExpandOption] = [],
                             page: PaginationParameters = PaginationParameters(),
                             completion: @escaping (_ result: Result<ResponseModel<[Transaction]>>) -> Void) {
        let endpoint = AddressesAPI.transactions(accountID: accountID, addressID: addressID, expandOptions: expandOptions, page: page)
        performRequest(for: endpoint, completion: completion)
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
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.Addresses.create`
    ///
    /// **Online API Documentation**
    ///
    /// [Create address](https://developers.coinbase.com/api/v2#create-address)
    ///
    public func create(accountID: String, name: String? = nil, completion: @escaping (_ result: Result<Address>) -> Void) {
        let endpoint = AddressesAPI.create(accountID: accountID, name: name)
        performRequest(for: endpoint, completion: completion)
    }
    
}

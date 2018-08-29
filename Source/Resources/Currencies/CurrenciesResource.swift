//
//  CurrenciesResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `CurrenciesResource` is a class which implements API methods for [Currencies](https://developers.coinbase.com/api/v2#currencies).
///
/// **Online API Documentation**
///
/// [Currencies](https://developers.coinbase.com/api/v2#currencies).
///
open class CurrenciesResource: BaseResource {

    /// Fetches a list of known currencies.
    ///
    /// - Parameters:
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get currencies](https://developers.coinbase.com/api/v2#get-currencies)
    ///
    public func get(completion: @escaping (_ result: Result<[CurrencyInfo]>) -> Void) {
        let endpoint = CurrenciesAPI.get
        performRequest(for: endpoint, completion: completion)
    }
    
}

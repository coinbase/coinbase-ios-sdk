//
//  ExchangeRatesResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `ExchangeRatesResource` is a class which implements API methods for [Exchange rates](https://developers.coinbase.com/api/v2#exchange-rates).
///
/// **Online API Documentation**
///
/// [Exchange rates](https://developers.coinbase.com/api/v2#exchange-rates)
///
open class ExchangeRatesResource: BaseResource {

    /// Fetches current exchange rates.
    ///
    /// Returned rates will define the exchange rate for one unit of the base currency.
    ///
    /// - Parameters:
    ///   - currency: Currency code for any known currency.
    ///
    ///       **Note**:
    ///
    ///       If parameter is `nil` default base currency(`USD`) will be used.
    ///
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
    /// [Get exchange rates](https://developers.coinbase.com/api/v2#get-exchange-rates)
    ///
    public func get(for currency: String? = nil, completion: @escaping (_ result: Result<ExchangeRates>) -> Void) {
        let endpoint = ExchangeRatesAPI.get(currency: currency)
        performRequest(for: endpoint, completion: completion)
    }
    
}

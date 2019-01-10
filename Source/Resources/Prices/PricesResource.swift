//
//  PricesResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Foundation

/// `PricesResource` is a class which implements API methods for [Prices](https://developers.coinbase.com/api/v2#prices).
///
/// **Online API Documentation**
///
/// [Prices](https://developers.coinbase.com/api/v2#prices).
///
open class PricesResource: BaseResource {

    /// Fetches the total price to buy one unit of crypto currency.
    ///
    /// - Note:
    ///     Exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     This buy price includes standard Coinbase fee (1%) but excludes any other fees including bank fees.
    ///
    ///     If you need more accurate price estimate for a specific payment method or amount,
    ///     see `BuyResource.placeOrder` and `quote: true` option.
    ///
    /// - Parameters:
    ///   - base: Crypto currency code.
    ///   - fiat: Fiat currency code.
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
    /// [Get buy price](https://developers.coinbase.com/api/v2#get-buy-price)
    ///
    public func buyPrice(base: String, fiat: String, completion: @escaping (_ result: Result<Price>) -> Void) {
        let endpoint = PricesAPI.buy(base: base, fiat: fiat)
        performRequest(for: endpoint, completion: completion)
    }

    /// Fetches the total price to sell one unit of crypto currency.
    ///
    /// - Note:
    ///     Note that exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     This sell price includes standard Coinbase fee (1%) but excludes any other fees including bank fees.
    ///
    ///     If you need more accurate price estimate for a specific payment method or amount,
    ///     see `SellResource.placeOrder` and `quote: true` option.
    ///
    /// - Parameters:
    ///   - base: Crypto currency code.
    ///   - fiat: Fiat currency code.
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
    /// [Get sell price](https://developers.coinbase.com/api/v2#get-sell-price)
    ///
    public func sellPrice(base: String, fiat: String, completion: @escaping (_ result: Result<Price>) -> Void) {
        let endpoint = PricesAPI.sell(base: base, fiat: fiat)
        performRequest(for: endpoint, completion: completion)
    }

    /// Fetches the current market price of crypto currency.
    ///
    /// This is usually somewhere in between the buy and sell price.
    ///
    /// - Note:
    ///     Exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     You can also get historic prices with `at:` parameter.
    ///
    /// - Parameters:
    ///   - base: Crypto currency code.
    ///   - fiat: Fiat currency code.
    ///   - at: The date for historic price.
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
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func spotPrice(base: String, fiat: String, at: Date, completion: @escaping (_ result: Result<Price>) -> Void) {
        spotPrice(base: base, fiat: fiat, at: priceDateFormater.string(from: at), completion: completion)
    }

    /// Fetches the current market price of crypto currency.
    ///
    /// This is usually somewhere in between the buy and sell price.
    ///
    /// - Note:
    ///     Exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     You can also get historic prices with `at:` parameter.
    ///
    /// - Parameters:
    ///   - base: Crypto currency code.
    ///   - fiat: Fiat currency code.
    ///   - at: The date string for historic price in format `YYYY-MM-DD` (UTC).
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
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func spotPrice(base: String, fiat: String, at: String? = nil, completion: @escaping (_ result: Result<Price>) -> Void) {
        let endpoint = PricesAPI.spot(base: base, fiat: fiat, at: at)
        performRequest(for: endpoint, completion: completion)
    }

    /// Fetches the current market price of crypto currency.
    ///
    /// This is usually somewhere in between the buy and sell price.
    ///
    /// - Note:
    ///     Exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     You can also get historic prices with `at:` parameter.
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency code.
    ///   - at: The date for historic price.
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
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func spotPrices(fiat: String, at: Date, completion: @escaping (_ result: Result<[Price]>) -> Void) {
        spotPrices(fiat: fiat, at: priceDateFormater.string(from: at), completion: completion)
    }

    /// Fetches the current market price of crypto currency.
    ///
    /// This is usually somewhere in between the buy and sell price.
    ///
    /// - Note:
    ///     Exchange rates fluctuates so the price is only correct for seconds at the time.
    ///
    ///     You can also get historic prices with `at:` parameter.
    ///
    /// - Parameters:
    ///   - fiat: Fiat currency code.
    ///   - at: The date string for historic price in format `YYYY-MM-DD` (UTC).
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
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func spotPrices(fiat: String, at: String? = nil, completion: @escaping (_ result: Result<[Price]>) -> Void) {
        let endpoint = PricesAPI.spotFor(fiat: fiat, at: at)
        performRequest(for: endpoint, completion: completion)
    }
    
    private var priceDateFormater: DateFormatter {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd"
        return formater
    }
    
}

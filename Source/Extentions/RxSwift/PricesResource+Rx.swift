//
//  PricesResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
import Foundation
#if !COCOAPODS
import CoinbaseSDK
#endif

/// MARK: - RxSwift extension for PricesResource

extension PricesResource {
    
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get buy price](https://developers.coinbase.com/api/v2#get-buy-price)
    ///
    public func rx_buyPrice(base: String, fiat: String) -> Single<Price> {
        return Single.create { single in
            self.buyPrice(base: base, fiat: fiat, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get sell price](https://developers.coinbase.com/api/v2#get-sell-price)
    ///
    public func rx_sellPrice(base: String, fiat: String) -> Single<Price> {
        return Single.create { single in
            self.sellPrice(base: base, fiat: fiat, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func rx_spotPrice(base: String, fiat: String, at: Date) -> Single<Price> {
        return Single.create { single in
            self.spotPrice(base: base, fiat: fiat, at: at, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func rx_spotPrice(base: String, fiat: String, at: String? = nil) -> Single<Price> {
        return Single.create { single in
            self.spotPrice(base: base, fiat: fiat, at: at, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func rx_spotPrices(fiat: String, at: Date) -> Single<[Price]> {
        return Single.create { single in
            self.spotPrices(fiat: fiat, at: at, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
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
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No permission required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price)
    ///
    public func rx_spotPrices(fiat: String, at: String? = nil) -> Single<[Price]> {
        return Single.create { single in
            self.spotPrices(fiat: fiat, at: at, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

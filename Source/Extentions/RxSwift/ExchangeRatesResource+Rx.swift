//
//  ExchangeRatesResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

/// MARK: - RxSwift extension for CurrenciesResource

extension ExchangeRatesResource {
    
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
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Get exchange rates](https://developers.coinbase.com/api/v2#get-exchange-rates)
    ///
    public func rx_get(for currency: String? = nil) -> Single<ExchangeRates> {
        return Single.create { single in
            self.get(for: currency, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

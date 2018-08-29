//
//  CurrenciesResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

/// MARK: - RxSwift extension for CurrenciesResource

extension CurrenciesResource {
    
    /// Fetches a list of known currencies.
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
    /// [Get currencies](https://developers.coinbase.com/api/v2#get-currencies)
    ///
    public func rx_get() -> Single<[CurrencyInfo]> {
        return Single.create { single in
            self.get(completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

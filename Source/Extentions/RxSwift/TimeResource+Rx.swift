//
//  TimeResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for TimeResource

extension TimeResource {
    
    /// Fetches the API server time.
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
    ///  [Get current time](https://developers.coinbase.com/api/v2#get-current-time)
    ///
    public func rx_get() -> Single<TimeInfo> {
        return Single.create { single in
            self.get(completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

//
//  UserResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for UserResource

extension UserResource {
    
    /// Fetches user's public information with their ID.
    ///
    /// - Parameters:
    ///   - id: ID of a User.
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
    /// [Show a user](https://developers.coinbase.com/api/v2#show-a-user)
    ///
    public func rx_get(by id: String) -> Single<User> {
        return Single.create { single in
            self.get(by: id, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches current user's public information.
    ///
    /// - Important:
    ///     To get user’s email or private information, use permissions `Scope.Wallet.User.email` and `Scope.Wallet.User.read`.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required for public data*
    ///   - `Scope.Wallet.User.read`
    ///   - `Scope.Wallet.User.email`
    ///
    /// **Online API Documentation**
    ///
    /// [Show current user](https://developers.coinbase.com/api/v2#show-current-user)
    ///
    public func rx_current() -> Single<User> {
        return Single.create { single in
            self.current(completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches current user’s authorization information including granted scopes and send limits when using OAuth2 authentication.
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
    /// [Show authorization information](https://developers.coinbase.com/api/v2#show-authorization-information)
    ///
    public func rx_authorizationInfo() -> Single<AuthorizationInfo> {
        return Single.create { single in
            self.authorizationInfo(completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Modifies current user and their preferences.
    ///
    /// - Parameters:
    ///   - name: User’s public name.
    ///   - timeZone: Time zone.
    ///   - nativeCurrency: Local currency used to display amounts converted from BTC.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.User.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Update current user](https://developers.coinbase.com/api/v2#update-current-user)
    ///
    public func rx_updateCurrent(name: String?,
                                 timeZone: String? = nil,
                                 nativeCurrency: String? = nil) -> Single<User> {
        return Single.create { single in
            self.updateCurrent(name: name,
                               timeZone: timeZone,
                               nativeCurrency: nativeCurrency,
                               completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

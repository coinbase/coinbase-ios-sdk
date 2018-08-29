//
//  TokenResource+Rx.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for TokenResource

extension TokenResource {
    
    /// Exchanges code for an access token and refresh token.
    ///
    /// After you have received the temporary `code`, you can exchange it for valid access and refresh tokens.
    /// The access token is used in requests required authentication, but it has an expiration date.
    ///
    /// - Note:
    ///     The refresh token never expires but it can only be exchanged once for a new set of access and refresh tokens.
    ///
    /// - Important:
    ///     Once an access token has expired, you will need to use the refresh token to obtain a new access token and a new
    ///     refresh token. If you try to make a call with an *expired* access token, a `401` response will be returned.
    ///
    ///     You can refresh tokens via `rx_refresh(clientID:,clientSecret:,redirectURI:)` call.
    ///
    /// - Parameters:
    ///   - code: Code retrieved from auth redirect URL.
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - redirectURI: Application’s redirect URI.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating)
    ///
    public func rx_get(code: String,
                       clientID: String,
                       clientSecret: String,
                       redirectURI: String) -> Single<UserToken> {
        return Single.create { single in
            self.get(code: code,
                     clientID: clientID,
                     clientSecret: clientSecret,
                     redirectURI: redirectURI,
                     completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches a new set of access and refresh tokens.
    ///
    /// - Note:
    ///     The refresh token never expires but it can only be exchanged once for a new set of access and refresh tokens.
    ///
    /// - Parameters:
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - refreshToken: Valid refresh token.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Online API Documentation**
    ///
    /// [Access and Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens)
    ///
    public func rx_refresh(clientID: String,
                           clientSecret: String,
                           refreshToken: String) -> Single<UserToken> {
        return Single.create { single in
            self.refresh(clientID: clientID,
                         clientSecret: clientSecret,
                         refreshToken: refreshToken,
                         completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Revokes access token.
    ///
    /// Access token can be revoked manually if you want to disconnect your application’s access to the user’s account.
    /// Revoking can also be used to implement a log-out feature.
    ///
    /// - Note:
    ///     Once token is successfully revoked both access token and refresh token become invalid.
    ///
    ///     To get new tokens user should pass through OAuth flow.
    ///
    /// - Returns:
    ///     `Single` containing requested model.
    ///
    /// **Online API Documentation**
    ///
    /// [Access and Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens)
    ///
    public func rx_revoke(accessToken: String) -> Single<EmptyData> {
        return Single.create { single in
            self.revoke(accessToken: accessToken, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

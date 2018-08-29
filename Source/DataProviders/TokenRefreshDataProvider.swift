//
//  TokenRefreshDataProvider.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Provides required properties for token refresh functionality.
internal class TokenRefreshDataProvider: TokenRefreshDataProviderProtocol {
    
    let clientID: String
    let clientSecret: String
    var refreshToken: String
    var onTokenUpdate: ((UserToken?) -> Void)?
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - refreshToken: Token which can be used to refresh expired access token.
    ///   - onTokenUpdate: Closure which gets called on every token update.
    ///
    internal init(clientID: String,
                  clientSecret: String,
                  refreshToken: String,
                  onTokenUpdate: ((UserToken?) -> Void)? = nil) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.refreshToken = refreshToken
        self.onTokenUpdate = onTokenUpdate
    }
    
}

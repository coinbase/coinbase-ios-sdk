//
//  AccessTokenProvider.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Provides access token.
public class AccessTokenProvider {
    
    /// Access token.
    public var accessToken: String?
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameter accessToken: Access token.
    ///
    public init(accessToken: String? = nil) {
        self.accessToken = accessToken
    }
    
}

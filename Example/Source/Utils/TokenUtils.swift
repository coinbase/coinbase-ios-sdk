//
//  TokenUtils.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import Foundation

public struct TokenUtils {
    
    private static let accessTokenKey = "accessTokenKey"
    private static let refreshTokenKey = "refreshTokenKey"
    
    public static func store(accessToken: String?, refreshToken: String?) {
        storeAccessToken(accessToken)
        storeRefreshToken(refreshToken)
    }
    
    public static func storeAccessToken(_ token: String?) {
        KeychainService.save(string: token, for: accessTokenKey)
    }
    
    public static func storeRefreshToken(_ token: String?) {
        KeychainService.save(string: token, for: refreshTokenKey)
    }
    
    public static func loadAccessToken() -> String? {
        return KeychainService.loadString(for: accessTokenKey)
    }
    
    public static func loadRefreshToken() -> String? {
        return KeychainService.loadString(for: refreshTokenKey)
        
    }
    
}

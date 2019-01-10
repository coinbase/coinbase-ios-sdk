//
//  CoinbaseManager.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import Foundation
import CoinbaseSDK

public struct CoinbaseManager {
    
    private static let kSuccessAlertTitle = "Success!"
    private static let kAuthSuccessAlertMessage = "You've been successfully authorized."
    
    public static var isLoggedIn: Bool {
        return TokenUtils.loadAccessToken() != nil
    }
    
    // MARK: - Public Methods
    
    public static func setupCoinbase() {
        guard let accessToken = TokenUtils.loadAccessToken(),
            let refreshToken = TokenUtils.loadRefreshToken() else {
                return
        }
        Coinbase.default.setRefreshStrategy(.refresh(clientID: OAuth2ApplicationKeys.clientID,
                                                     clientSecret: OAuth2ApplicationKeys.clientSecret,
                                                     refreshToken: refreshToken,
                                                     onUserTokenUpdate: ({ token in
                                                        CoinbaseManager.storeToken(token)
                                                        if token == nil {
                                                            RootControllerCoordinator.setRoot(.authorization)
                                                        }
                                                     })))
        Coinbase.default.accessToken = accessToken
    }
    
    public static func completeAuthorization(with result: Result<UserToken>) {
        switch result {
        case .success(let value):
            CoinbaseManager.storeToken(value)
            RootControllerCoordinator.setRoot(.mainMenu)
            RootControllerCoordinator.rootViewController?.presentSimpleAlert(title: CoinbaseManager.kSuccessAlertTitle,
                                                                             message: CoinbaseManager.kAuthSuccessAlertMessage)
        case .failure(let error):
            RootControllerCoordinator.rootViewController?.present(error: error)
        }
        
        CoinbaseManager.setupCoinbase()
    }
    
    // MARK: - Private Methods
    
    private static func storeToken(_ token: UserToken?) {
        TokenUtils.store(accessToken: token?.accessToken, refreshToken: token?.refreshToken)
    }
    
}

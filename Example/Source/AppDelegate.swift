//
//  AppDelegate.swift
//  iOS Example
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import UIKit
import CoinbaseSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        CoinbaseManager.setupCoinbase()
        
        setupAppearance()
        
        RootControllerCoordinator.setRoot(CoinbaseManager.isLoggedIn ? .mainMenu : .authorization, animated: false)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        if Coinbase.default.oauth.isDeeplinkRedirect(url: url) {
            return true
        }
        let handleCoinbaseOauth = Coinbase.default.oauth.completeAuthorization(url) { result in
            CoinbaseManager.completeAuthorization(with: result)
        }
        
        return handleCoinbaseOauth
    }
    
    // MARK: - Private Methods
    
    private func setupAppearance() {
        UIBarButtonItem.appearance().tintColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont(name: Fonts.medium, size: 16)!,
                                                             NSAttributedStringKey.foregroundColor: UIColor.white],
                                                            for: .normal)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: Fonts.demiBold, size: 19)!,
                                                            NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().barTintColor = Colors.lightBlue
    }
    
}

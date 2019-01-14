//
//  MockedURLOpener.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import CoinbaseSDK

class MockedURLOpener: URLOpenerProtocol {
    
    var allowURLOpenning = true
    var openedURL: URL?
    
    func canOpenURL(_ url: URL) -> Bool {
        print(#function)
        return allowURLOpenning
    }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        print(#function)
        openedURL = url
    }
    
}

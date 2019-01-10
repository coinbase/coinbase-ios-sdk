//
//  URLSessionProviderProtocol.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Defines required properties to provide `URLSession`.
internal protocol URLSessionProviderProtocol {
    /// Session.
    var session: URLSession { get }
}

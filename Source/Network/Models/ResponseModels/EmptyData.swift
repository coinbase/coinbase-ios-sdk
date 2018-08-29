//
//  EmptyData.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents empty response from server.
/// 
public struct EmptyData: ConvertibleFromData, Decodable {
    static public func convert(from data: Data) throws -> EmptyData {
        return EmptyData()
    }
}

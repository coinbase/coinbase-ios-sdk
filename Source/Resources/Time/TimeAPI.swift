//
//  TimeAPI.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `TimeAPI` defines required parameters to create and validate all API requests
/// for [Time](https://developers.coinbase.com/api/v2#time).
///
/// - get: Represents [Get current time](https://developers.coinbase.com/api/v2#get-current-time) API request.
///
public enum TimeAPI: ResourceAPIProtocol {
    
    /// Represents [Get current time](https://developers.coinbase.com/api/v2#get-current-time) API request.
    case get

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        return "/\(PathConstants.time)"
    }

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: RequestParameters? {
        return nil
    }
    
}

//
//  CurrenciesAPI.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// `CurrenciesAPI` defines required parameters to create and validate all API requests
/// for [Currencies](https://developers.coinbase.com/api/v2#currencies).
///
/// - get: Represents [Get currencies](https://developers.coinbase.com/api/v2#get-currencies) API request.
///
public enum CurrenciesAPI: ResourceAPIProtocol {

    /// Represents [Get currencies](https://developers.coinbase.com/api/v2#get-currencies) API request.
    case get

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .get:
            return "/\(PathConstants.currencies)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }

    public var parameters: RequestParameters? {
        switch self {
        case .get:
            return nil
        }
    }

}

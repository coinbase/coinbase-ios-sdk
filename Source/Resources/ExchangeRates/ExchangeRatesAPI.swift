//
//  ExchangeRatesAPI.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `ExchangeRatesAPI` defines required parameters to create and validate all API requests
/// for [Exchange rates](https://developers.coinbase.com/api/v2#exchange-rates).
///
/// - get: Represents [Get exchange rates](https://developers.coinbase.com/api/v2#get-exchange-rates) API request.
///
public enum ExchangeRatesAPI: ResourceAPIProtocol {

    /// Represents [Get exchange rates](https://developers.coinbase.com/api/v2#get-exchange-rates) API request.
    case get(currency: String?)

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        return "/\(PathConstants.exchangeRates)"
    }

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: RequestParameters? {
        switch self {
        case let .get(.some(currency)):
            return .get([ParameterKeys.currency: currency])
        default: return nil
        }
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let currency = "currency"
    }
    
}

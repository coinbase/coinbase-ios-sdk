//
//  PricesAPI.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `PricesAPI` defines required parameters to create and validate all API requests
/// for [Prices resource](https://developers.coinbase.com/api/v2#prices).
///
/// - buy: Represents [Get buy price](https://developers.coinbase.com/api/v2#get-buy-price) API request.
/// - sell: Represents [Get sell price](https://developers.coinbase.com/api/v2#get-sell-price) API request.
/// - spot: Represents [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price) API request.
/// - spotFor: Represents [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price) API request to fetch prices for all crypto currencies.
///
public enum PricesAPI: ResourceAPIProtocol {
    
    /// Represents [Get buy price](https://developers.coinbase.com/api/v2#get-buy-price) API request.
    case buy(base: String, fiat: String)
    /// Represents [Get sell price](https://developers.coinbase.com/api/v2#get-sell-price) API request.
    case sell(base: String, fiat: String)
    /// Represents [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price) API request.
    case spot(base: String, fiat: String, at: String?)
    /// Represents [Get spot price](https://developers.coinbase.com/api/v2#get-spot-price) API request to fetch prices for all crypto currencies.
    case spotFor(fiat: String, at: String?)

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case let .buy(base, fiat):
            return "/\(PathConstants.prices)/\(base)-\(fiat)/\(PathConstants.buy)"
        case let .sell(base, fiat):
            return "/\(PathConstants.prices)/\(base)-\(fiat)/\(PathConstants.sell)"
        case let .spot(base, fiat, _):
            return "/\(PathConstants.prices)/\(base)-\(fiat)/\(PathConstants.spot)"
        case let .spotFor(fiat, _):
            return "/\(PathConstants.prices)/\(fiat)/\(PathConstants.spot)"
        }
    }

    public var method: HTTPMethod {
        return .get
    }

    public var parameters: RequestParameters? {
        switch self {
        case let .spot(_, _, .some(date)),
             let .spotFor(_, .some(date)):
            return .get([ParameterKeys.date: date])
        default: return nil
        }
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let date = "date"
    }
    
}

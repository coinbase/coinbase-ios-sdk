//
//  TradesAPI.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Trade Resource type definitions.
///
/// - buys: Trade Resource of type [Buys](https://developers.coinbase.com/api/v2#buys).
/// - sells: Trade Resource of type [Sells](https://developers.coinbase.com/api/v2#sells).
/// - deposits: Trade Resource of type [Deposits](https://developers.coinbase.com/api/v2#deposits).
/// - withdrawals: Trade Resource of type [Withdrawals](https://developers.coinbase.com/api/v2#withdrawals).
public enum TradeResourceType: String {
    /// Trade Resource of type [Buys](https://developers.coinbase.com/api/v2#buys).
    case buys
    /// Trade Resource of type [Sells](https://developers.coinbase.com/api/v2#sells).
    case sells
    /// Trade Resource of type [Deposits](https://developers.coinbase.com/api/v2#deposits).
    case deposits
    /// Trade Resource of type [Withdrawals](https://developers.coinbase.com/api/v2#withdrawals).
    case withdrawals
}

/// `TradesAPI` defines required parameters to create and validate all API requests for Trade Resources.
///
/// - list: Represents List API request.
/// - show: Represents Show API request.
/// - placeOrder: Represents Place Order API request.
/// - commit: Represents Commit Order API request.
///
public enum TradesAPI: ResourceAPIProtocol {
    
    /// Represents List API request.
    case list(tradeType: TradeResourceType, accountID: String, expandOptions: [TradeExpandOption], page: PaginationParameters)
    /// Represents Show API request.
    case show(tradeType: TradeResourceType, accountID: String, tradeID: String, expandOptions: [TradeExpandOption])
    /// Represents Place Order API request.
    case placeOrder(tradeType: TradeResourceType, accountID: String, expandOptions: [TradeExpandOption], parameters: DictionaryConvertible)
    /// Represents Commit Order API request.
    case commit(tradeType: TradeResourceType, accountID: String, tradeID: String, expandOptions: [TradeExpandOption])
    
    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case let .list(type, accountID, _, _),
             let .placeOrder(type, accountID, _, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(type.rawValue)"
        case let .show(type, accountID, tradeID, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(type.rawValue)/\(tradeID)"
        case let .commit(type, accountID, tradeID, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(type.rawValue)/\(tradeID)/\(PathConstants.commit)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .list,
             .show:
            return .get
        case .placeOrder,
             .commit:
            return .post
        }
    }
    
    public var parameters: RequestParameters? {
        switch self {
        case .list(_, _, _, let page):
            return .get(page.parameters)
        case .placeOrder(_, _, _, let parameters):
            return .body(parameters.toDictionary)
        default:
            return nil
        }
    }
    
    public var authentication: AuthenticationType {
        return .token
    }
    
    public var expandOptions: [String] {
        switch self {
        case .list(_, _, let expandOptions, _),
             .show(_, _, _, let expandOptions),
             .placeOrder(_, _, let expandOptions, _),
             .commit(_, _, _, let expandOptions):
            return expandOptions.rawValues
        }
    }
    
}

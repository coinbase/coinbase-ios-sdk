//
//  AddressesAPI.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `AddressesAPI` defines required parameters to create and validate all API requests
/// for [Address Resource](https://developers.coinbase.com/api/v2#addresses).
///
/// - list: Represents [List addresses](https://developers.coinbase.com/api/v2#list-addresses) API request.
/// - address: Represents [Show address](https://developers.coinbase.com/api/v2#list-addresses) API request.
/// - transactions: Represents [List address’s transactions](https://developers.coinbase.com/api/v2#list-addresses) API request.
/// - create: Represents [Create address](https://developers.coinbase.com/api/v2#list-addresses) API request.
///
public enum AddressesAPI: ResourceAPIProtocol {
    
    /// Represents [List addresses](https://developers.coinbase.com/api/v2#list-addresses) API request.
    case list(accountID: String, page: PaginationParameters)
    /// Represents [Show address](https://developers.coinbase.com/api/v2#list-addresses) API request.
    case address(accountID: String, addressID: String)
    /// Represents [List address’s transactions](https://developers.coinbase.com/api/v2#list-addresses) API request.
    case transactions(accountID: String, addressID: String, expandOptions: [TransactionExpandOption], page: PaginationParameters)
    /// Represents [Create address](https://developers.coinbase.com/api/v2#list-addresses) API request.
    case create(accountID: String, name: String?)
    
    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .list(let accountID, _),
             .create(let accountID, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.addresses)"
        case .address(let accountID, let addressID):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.addresses)/\(addressID)"
        case .transactions(let accountID, let addressID, _, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.addresses)/\(addressID)/\(PathConstants.transactions)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .list,
             .address,
             .transactions:
            return .get
        case .create:
            return .post
        }
    }
    
    public var parameters: RequestParameters? {
        switch self {
        case .list(_, let page),
             .transactions(_, _, _, let page):
            return .get(page.parameters)
        case .create(_, let name) where name != nil:
            return .body([ParameterKeys.name: name!])
        default:
            return nil
        }
    }
    
    public var authentication: AuthenticationType {
        return .token
    }
    
    public var expandOptions: [String] {
        switch self {
        case let .transactions(_, _, expandOptions, _):
            return expandOptions.map { $0.rawValue }
        default:
            return []
        }
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let name = "name"
    }
    
}

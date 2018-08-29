//
//  AccountsAPI.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
// 

/// `AccountsAPI` defines required parameters to create and validate all API requests
/// for [Account resource](https://developers.coinbase.com/api/v2#accounts).
///
/// - list: Represents [List accounts methods](https://developers.coinbase.com/api/v2#list-accounts) API request.
/// - account: Represents [Show an account method](https://developers.coinbase.com/api/v2#show-an-account) API request.
/// - setPrimary: Represents [Set account as primary method](https://developers.coinbase.com/api/v2#set-account-as-primary) API request.
/// - update: Represents [Update account method](https://developers.coinbase.com/api/v2#update-account) API request.
/// - delete: Represents [Delete account method](https://developers.coinbase.com/api/v2#delete-account) API request.
///
public enum AccountsAPI: ResourceAPIProtocol {
    
    /// Represents [List accounts methods](https://developers.coinbase.com/api/v2#list-accounts) API request.
    case list(page: PaginationParameters)
    /// Represents [Show an account method](https://developers.coinbase.com/api/v2#show-an-account) API request.
    case account(id: String)
    /// Represents [Set account as primary method](https://developers.coinbase.com/api/v2#set-account-as-primary) API request.
    case setPrimary(id: String)
    /// Represents [Update account method](https://developers.coinbase.com/api/v2#update-account) API request.
    case update(id: String, name: String)
    /// Represents [Delete account method](https://developers.coinbase.com/api/v2#delete-account) API request.
    case delete(id: String)
    
    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .account(let id),
             .update(let id, _),
             .delete(let id):
            return "/\(PathConstants.accounts)/\(id)"
        case .list:
            return "/\(PathConstants.accounts)"
        case .setPrimary(let id):
            return "/\(PathConstants.accounts)/\(id)/\(PathConstants.primary)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .list,
             .account:    return .get
        case .setPrimary: return .post
        case .update:     return .put
        case .delete:     return .delete
        }
    }
    
    public var parameters: RequestParameters? {
        switch self {
        case .update(_, let name):
            return .body([ParameterKeys.name: name])
        case .list(let page):
            return .get(page.parameters)
        default:
            return nil
        }
    }
    
    public var authentication: AuthenticationType {
        return .token
    }
    
    public var allowEmptyResponse: Bool {
        switch self {
        case .delete: return true
        default: return false
        }
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let name = "name"
    }
    
}

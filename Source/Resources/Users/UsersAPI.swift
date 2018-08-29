//
//  UsersAPI.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

/// `UsersAPI` defines required parameters to create and validate all API requests
/// for [User Resource](https://developers.coinbase.com/api/v2#users).
///
/// - user: Represents [Show a user](https://developers.coinbase.com/api/v2#show-a-user) API request.
/// - currentUser: Represents [Show current user](https://developers.coinbase.com/api/v2#show-current-user) API request.
/// - authorizationInfo: Represents [Show authorization information](https://developers.coinbase.com/api/v2#show-authorization-information) API request.
/// - update: Represents [Update current user](https://developers.coinbase.com/api/v2#update-current-user) API request.
///
public enum UsersAPI: ResourceAPIProtocol {
    
    /// Represents [Show a user](https://developers.coinbase.com/api/v2#show-a-user) API request.
    case user(id: String)
    /// Represents [Show current user](https://developers.coinbase.com/api/v2#show-current-user) API request.
    case currentUser
    /// Represents [Show authorization information](https://developers.coinbase.com/api/v2#show-authorization-information) API request.
    case authorizationInfo
    /// Represents [Update current user](https://developers.coinbase.com/api/v2#update-current-user) API request.
    case update(name: String?, timeZone: String?, nativeCurrency: String?)

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .user(let id):
            return "/\(PathConstants.users)/\(id)"
        case .currentUser,
             .update:
            return "/\(PathConstants.user)"
        case .authorizationInfo:
            return "/\(PathConstants.user)/\(PathConstants.auth)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .user,
             .currentUser,
             .authorizationInfo:
            return .get
        case .update:
            return .put
        }
    }

    public var parameters: RequestParameters? {
        switch self {
        case .user,
             .currentUser,
             .authorizationInfo:
            return nil
        case .update(let name, let timeZone, let nativeCurrency):
            var parameters: [String: String] = [:]
            if let name = name {
                parameters[ParameterKeys.name] = name
            }
            if let timeZone = timeZone {
                parameters[ParameterKeys.timeZone] = timeZone
            }
            if let nativeCurrency = nativeCurrency {
                parameters[ParameterKeys.nativeCurrency] = nativeCurrency
            }

            return .body(parameters)
        }
    }

    public var authentication: AuthenticationType {
        return .token
    }

    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let name = "name"
        static let timeZone = "time_zone"
        static let nativeCurrency = "native_currency"
    }
    
}

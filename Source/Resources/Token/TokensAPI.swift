//
//  TokensAPI.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// `TokensAPI` defines required parameters to create and validate all API Token requests.
///
/// - get: Represents [Exchange code for tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating) API request.
/// - refresh: Represents [Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens) API request.
/// - revoke: Represents [Revoke tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens) API request.
///
public enum TokensAPI: ResourceAPIProtocol {

    /// Represents [Exchange code for tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating) API request.
    case get(code: String, clientID: String, clientSecret: String, redirectURI: String)
    /// Represents [Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens) API request.
    case refresh(clientID: String, clientSecret: String, refreshToken: String)
    /// Represents [Revoke tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens) API request.
    case revoke(accessToken: String)

    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .get,
             .refresh:
            return "/\(PathConstants.oauth)/\(PathConstants.token)"
        case .revoke:
            return "/\(PathConstants.oauth)/\(PathConstants.revoke)"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .get,
             .refresh,
             .revoke:
            return .post
        }
    }

    public var parameters: RequestParameters? {
        switch self {
        case .get(let code, let clientID, let clientSecret, let redirectURI):
            let parameters: [String: String] = [
                ParameterKeys.grantType: GrantTypes.authorizationCode,
                ParameterKeys.code: code,
                ParameterKeys.clientID: clientID,
                ParameterKeys.clientSecret: clientSecret,
                ParameterKeys.redirectURI: redirectURI
                ]
            return .body(parameters)
        case .refresh(let clientID, let clientSecret, let refreshToken):
            let parameters: [String: String] = [
                ParameterKeys.grantType: GrantTypes.refreshToken,
                ParameterKeys.clientID: clientID,
                ParameterKeys.clientSecret: clientSecret,
                ParameterKeys.refreshToken: refreshToken
                ]
            return .body(parameters)
        case .revoke(let token):
            return .body([ParameterKeys.token: token])
        }
    }

    public var authentication: AuthenticationType {
        switch self {
        case .get,
             .refresh,
             .revoke:
            return .none
        }
    }

    public var errorResponseType: ErrorResponseType {
        return .oauth
    }
    
    public var allowEmptyResponse: Bool {
        switch self {
        case .revoke: return true
        default: return false
        }
    }

    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let grantType = "grant_type"
        static let code = "code"
        static let clientID = "client_id"
        static let clientSecret = "client_secret"
        static let redirectURI = "redirect_uri"
        static let refreshToken = "refresh_token"
        static let token = "token"
    }
    
    private struct GrantTypes {
        static let authorizationCode = "authorization_code"
        static let refreshToken = "refresh_token"
    }
    
}

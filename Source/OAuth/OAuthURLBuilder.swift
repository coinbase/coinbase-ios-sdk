//
//  OAuthURLBuilder.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Builder struct for authorization URL.
internal struct OAuthURLBuilder {
    
    /// Returns an authorization URL from given parameters.
    ///
    /// - Parameters:
    ///   - oauthKeys: Source of base oauth parameters(ClientID, ClientSecret, etc.)
    ///   - layout: Page to display on redirect.
    ///
    ///       If `layout` is not provided, login page is shown by default.
    ///
    ///       **See also**
    ///
    ///       `Layout` constants.
    ///
    ///   - scope: An array of scopes application requests access to.
    ///
    ///       **See also**
    ///
    ///       `Scope` constants.
    ///
    ///   - state: An unguessable random string. It is used to protect against cross-site request forgery attacks.
    ///
    ///       Read more about state
    ///         [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/security-best-practices#state-variable).
    ///
    ///   - accountAccess: Access type to user’s accounts.
    ///   - meta: A dictionary with additional parameters.
    ///
    ///       **See also**
    ///
    ///       `Meta.SendLimit` constants.
    ///
    ///
    /// - Returns: Authorization URL with the correct parameters and scopes.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating),
    /// [Account access, Send limits](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions),
    /// [Permissions(scopes)](https://developers.coinbase.com/docs/wallet/permissions)
    ///
    static func authorizationURL(oauthKeys: OAuthKeys,
                                 layout: String? = nil,
                                 scope: [String]? = nil,
                                 state: String? = nil,
                                 accountAccess: AccountAccess? = nil,
                                 meta: [String: String]? = nil) -> URL? {
        var urlComponents = URLComponents()

        urlComponents.scheme = OAuthConstants.AuthorizationURL.scheme
        urlComponents.host = OAuthConstants.AuthorizationURL.host
        urlComponents.path = OAuthConstants.AuthorizationURL.path

        var queryItems = [
            URLQueryItem(name: ParameterKeys.responseType, value: ResponseTypes.code),
            URLQueryItem(name: ParameterKeys.clientID, value: oauthKeys.clientID),
            URLQueryItem(name: ParameterKeys.redirectURI, value: oauthKeys.redirectURI.removingPercentEncoding)
        ]
        if let layout = layout {
            queryItems.append(URLQueryItem(name: ParameterKeys.layout, value: layout))
        }
        if let scope = scope {
            let scopeString = scope.joined(separator: ",")
            queryItems.append(URLQueryItem(name: ParameterKeys.scope, value: scopeString))
        }
        if let state = state {
            queryItems.append(URLQueryItem(name: ParameterKeys.state, value: state))
        }
        if let accountAccess = accountAccess {
            queryItems.append(URLQueryItem(name: ParameterKeys.account, value: accountAccess.stringValue))
        }
        if let accountCurrency = accountAccess?.currency {
            queryItems.append(URLQueryItem(name: ParameterKeys.accountCurrency, value: accountCurrency))
        }
        meta?.forEach {
            queryItems.append(URLQueryItem(name: "\(ParameterKeys.meta)[\($0)]", value: $1))
        }

        urlComponents.queryItems = queryItems

        return urlComponents.url
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let responseType = "response_type"
        static let clientID = "client_id"
        static let redirectURI = "redirect_uri"
        static let layout = "layout"
        static let scope = "scope"
        static let state = "state"
        static let account = "account"
        static let accountCurrency = "account_currency"
        static let meta = "meta"
    }
    
    private struct ResponseTypes {
        static let code = "code"
    }
    
}

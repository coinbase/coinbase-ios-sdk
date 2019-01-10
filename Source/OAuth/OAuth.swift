//
//  OAuth.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Represents keys required for API Access.
internal struct OAuthKeys {
    /// The client ID received after registering application.
    let clientID: String
    /// The client secret received after registering application.
    let clientSecret: String
    /// Application’s redirect URI.
    /// The URL where users will be sent after authorization.
    ///
    /// Read more about redirect URI
    /// [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/security-best-practices#oauth2-redirect-uri).
    ///
    let redirectURI: String
    /// Application’s verification deeplink URI.
    ///
    /// Sign up and login within the OAuth2 flow requires the user to verify their device and/or email by opening a link
    /// that Coinbase sends in a verification email. A special verifications deeplink can be specified as part of
    /// OAuth application’s *advanced settings*.
    ///
    /// This link will be opened automatically on successful verification.
    ///
    /// Read more about verification deeplink
    /// [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/mobile#verification-deeplink).
    var deeplinkURI: String?
    /// Contains redirect URI and deeplinkURI if present.
    var redirectURIs: [String] {
        var redirectURIs = [redirectURI]
        if let deeplinkURI = deeplinkURI {
            redirectURIs.append(deeplinkURI)
        }
        return redirectURIs
    }
    
}

/// Provides all required methods for authorization.
///
/// - Important:
///     You need to call `configure(clientID:clientSecret:redirectURI:)` before calling any authorization method.
///
open class OAuth {
    
    private var state: String?
    private weak var tokenResource: TokenResource?
    private var oauthKeys: OAuthKeys?
    
    internal var redirectURIsValidator: RedirectURIsValidatorProtocol = RedirectURIsValidator()
    
    // MARK: - Initializer Methods
    
    /// Creates a new instance with given tokenResource parameter.
    ///
    /// - Parameter tokenResource: Resource that provides method to exchange `code` for valid tokens.
    ///
    public init(tokenResource: TokenResource) {
        self.tokenResource = tokenResource
    }
    
    // MARK: - Configuration Methods
    
    /// Is used to setup all parameters required for OAuth requests.
    ///
    /// - Important:
    ///     This method is **required**. Call it before calling any authorization method.
    ///
    /// - Parameters:
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - redirectURI: Application’s redirect URI.
    ///   - deeplinkURI: Application’s verification deeplink URI.
    ///
    public func configure(clientID: String,
                          clientSecret: String,
                          redirectURI: String,
                          deeplinkURI: String? = nil) {
        self.oauthKeys = OAuthKeys(clientID: clientID,
                                   clientSecret: clientSecret,
                                   redirectURI: redirectURI,
                                   deeplinkURI: deeplinkURI)
    }
    
    // MARK: - Public Methods
    
    /// Checks if provided URL matches verification deeplink URI.
    ///
    /// - Note:
    ///     This method verifies URL against `deeplinkURI` parameter passed with
    ///     `configure(clientID:clientSecret:redirectURI:deeplinkURI:)` method.
    ///
    /// - Parameter url: URL to check.
    /// - Returns: `false` if URL doesn't match verification deeplink URI; otherwise, `true`.
    ///
    public func isDeeplinkRedirect(url: URL) -> Bool {
        return url.absoluteString == self.oauthKeys?.deeplinkURI
    }
    
    /// Processes received URL and attempt to fetch token.
    ///
    /// - Important:
    ///     This method should be called on the **same** instance of `OAuth` where `beginAuthorization` was
    ///     called on. This requirement is needed to protect against CSRF attacks.
    ///     **Otherwise** method **will fail** with `OAuthError.incorrectStateParameterInResponse` error.
    ///
    /// - Parameters:
    ///   - url: URL received from Coinbase.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// - Returns: `false` if URL can't be handled; otherwise, `true`.
    ///
    public func completeAuthorization(_ url: URL, completion: @escaping (_ result: Result<UserToken>) -> Void) -> Bool {
        
        guard let oauthKeys = oauthKeys else {
            completion(.failure(OAuthError.configurationMissing))
            return false
        }
        
        guard canHandleURL(url, with: oauthKeys) else {
            completion(.failure(OAuthError.cantHandleURL(url: url)))
            return false
        }
        
        let components = URLComponents(string: url.absoluteString)
        guard let queryItems = components?.queryItems else {
            completion(.failure(OAuthError.malformedResponse(url: url)))
            return true
        }
        
        var receivedState: String?
        var receivedCode: String?
        
        for item in queryItems {
            switch item.name {
            case "code":
                receivedCode = item.value
            case "state":
                receivedState = item.value
            default:
                break
            }
        }
        
        guard receivedState == state else {
            completion(.failure(OAuthError.incorrectStateParameterInResponse(state: receivedState, expectedState: state)))
            return true
        }
        
        guard let code = receivedCode else {
            completion(.failure(OAuthError.missingCodeParameterInResponse(url: url)))
            return true
        }
        
        exchangeCodeForUserToken(code: code, with: oauthKeys, completion: completion)
        
        return true
    }
    
    // MARK: - Private Methods
    
    /// Redirects users to request Coinbase access.
    ///
    /// - Parameters:
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
    ///       Read more about scopes [here](https://developers.coinbase.com/docs/wallet/permissions).
    ///
    ///   - state: An unguessable random string. It is used to protect against cross-site request forgery attacks.
    ///
    ///       If `state` is not provided, default random string is used.
    ///
    ///       Read more about state [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/security-best-practices#state-variable).
    ///
    ///   - accountAccess: Access type to user’s accounts.
    ///   - meta: A dictionary with additional parameters.
    ///
    ///       **See also**
    ///
    ///       `Meta.SendLimit` constants.
    ///
    ///   - urlOpener: Instance that should check and open URLs.
    ///
    /// - Throws: An `OAuthError` if the OAuth failed to create or to open URL from given parameters.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating),
    /// [Account access, Send limits](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions),
    /// [Permissions(scopes)](https://developers.coinbase.com/docs/wallet/permissions)
    ///
    private func beginAuthorization(layout: String? = nil,
                                    scope: [String]? = nil,
                                    state: String? = nil,
                                    accountAccess: AccountAccess? = nil,
                                    meta: [String: String]? = nil,
                                    urlOpener: URLOpenerProtocol) throws {
        guard let oauthKeys = oauthKeys else {
            throw OAuthError.configurationMissing
        }
        try redirectURIsValidator.validate(oauthKeys.redirectURIs)
        self.state = state ?? String.randomAlphaNumericString(length: OAuthConstants.defaultStateLength)
        let authorizationURL = OAuthURLBuilder.authorizationURL(oauthKeys: oauthKeys,
                                                                layout: layout,
                                                                scope: scope,
                                                                state: self.state,
                                                                accountAccess: accountAccess,
                                                                meta: meta)
        
        guard let url = authorizationURL, urlOpener.canOpenURL(url) else {
            throw OAuthError.cantRedirectTo(url: authorizationURL)
        }
        
        urlOpener.open(url, options: [:], completionHandler: nil)
    }
    
    /// Checks whether provided URL could be handled by SDK.
    ///
    /// - Parameter url: URL to check.
    /// - Returns: `true` in case URL has prefix matching application’s redirect URI; otherwise, `false`.
    ///
    private func canHandleURL(_ url: URL, with oauthKeys: OAuthKeys) -> Bool {
        let lowercasedRedirectURI = oauthKeys.redirectURI.lowercased()
        let lowercasedURLToHandle = url.absoluteString.lowercased()
        
        return lowercasedURLToHandle.hasPrefix(lowercasedRedirectURI)
    }
    
    /// Attempts to exchange temporary `code` for valid tokens.
    ///
    /// - Note:
    ///     Fails with `OAuthError.configurationMissing` in case method is called before `setup` method.
    ///
    /// - Parameters:
    ///   - code: `code` from redirected URL.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    private func exchangeCodeForUserToken(code: String, with oauthKeys: OAuthKeys, completion: @escaping (_ result: Result<UserToken>) -> Void) {
        tokenResource?.get(code: code,
                           clientID: oauthKeys.clientID,
                           clientSecret: oauthKeys.clientSecret,
                           redirectURI: oauthKeys.redirectURI,
                           completion: completion)
    }
    
}

#if os(iOS)

extension OAuth {
    
    /// Redirects users to request Coinbase access.
    ///
    /// - Parameters:
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
    ///       Read more about scopes [here](https://developers.coinbase.com/docs/wallet/permissions).
    ///
    ///   - state: An unguessable random string. It is used to protect against cross-site request forgery attacks.
    ///
    ///       If `state` is not provided, default random string is used.
    ///
    ///       Read more about state [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/security-best-practices#state-variable).
    ///
    ///   - accountAccess: Access type to user’s accounts.
    ///   - meta: A dictionary with additional parameters.
    ///
    ///       **See also**
    ///
    ///       `Meta.SendLimit` constants.
    ///
    ///   - flowType: Type of OAuth flow.
    ///
    /// - Throws: An `OAuthError` if the OAuth failed to create or to open URL from given parameters.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating),
    /// [Account access, Send limits](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions),
    /// [Permissions(scopes)](https://developers.coinbase.com/docs/wallet/permissions),
    /// [Verification deeplink](https://developers.coinbase.com/docs/wallet/coinbase-connect/mobile#verification-deeplink)
    ///
    public func beginAuthorization(layout: String? = nil,
                                   scope: [String]? = nil,
                                   state: String? = nil,
                                   account: AccountAccess? = nil,
                                   meta: [String: String]? = nil,
                                   flowType: OAuthFlowType = .inSafari) throws {
        try self.beginAuthorization(layout: layout,
                                    scope: scope,
                                    state: state,
                                    accountAccess: account,
                                    meta: meta,
                                    urlOpener: flowType.opener)
    }
    
}

#else

// Extension to expose `beginAuthorization` method to not iOS platforms.
extension OAuth {
    
    /// Redirects users to request Coinbase access.
    ///
    /// - Parameters:
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
    ///       Read more about scopes [here](https://developers.coinbase.com/docs/wallet/permissions).
    ///
    ///   - state: An unguessable random string. It is used to protect against cross-site request forgery attacks.
    ///
    ///       If `state` is not provided, default random string is used.
    ///
    ///       Read more about state [here](https://developers.coinbase.com/docs/wallet/coinbase-connect/security-best-practices#state-variable).
    ///
    ///   - account: Access type to user’s accounts.
    ///   - meta: A dictionary with additional parameters.
    ///
    ///       **See also**
    ///
    ///       `Meta.SendLimit` constants.
    ///
    ///   - urlOpener: Instance that should check and open URLs.
    ///
    /// - Throws: An `OAuthError` if the OAuth failed to create or to open URL from given parameters.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating),
    /// [Account access, Send limits](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions),
    /// [Permissions(scopes)](https://developers.coinbase.com/docs/wallet/permissions)
    ///
    public func beginAuthorization(layout: String? = nil,
                                   scope: [String]? = nil,
                                   state: String? = nil,
                                   account: AccountAccess? = nil,
                                   meta: [String: String]? = nil,
                                   urlOpener: URLOpenerProtocol) throws {
        try self.beginAuthorization(layout: layout,
                                    scope: scope,
                                    state: state,
                                    accountAccess: account,
                                    meta: meta,
                                    urlOpener: urlOpener)
    }
    
}

#endif

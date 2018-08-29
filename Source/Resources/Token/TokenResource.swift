//
//  TokenResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// Defines methods for listener of `UserToken`.
public protocol UserTokenListener: class {
    
    /// Get called whenever `UserToken` is updated.
    ///
    /// - Parameter token: Updated `UserToken`.
    ///
    func onUpdate(token: UserToken?)
    
}

/// `TokenResource` is a class which implements API methods for getting, refreshing or revoking tokens.
///
/// **Online API Documentation**
///
/// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating),
/// [Refresh Tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens)
///
open class TokenResource: BaseResource {
    
    private weak var tokenListener: UserTokenListener?

    // MARK: - Initializer Method
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - sessionManager: Session manager.
    ///   - baseURL: Base URL.
    ///   - tokenListener: Token listener.
    ///
    public init(sessionManager: SessionManagerProtocol, baseURL: String, tokenListener: UserTokenListener? = nil) {
        self.tokenListener = tokenListener
        super.init(sessionManager: sessionManager, baseURL: baseURL)
    }

    // MARK: - Public Methods
    
    /// Exchanges `code` for an access token and refresh token.
    ///
    /// After you have received the temporary `code`, you can exchange it for valid access and refresh tokens.
    /// The access token is used in requests required authentication, but it has an expiration date.
    ///
    /// - Note:
    ///     The refresh token never expires but it can only be exchanged once for a new set of access and refresh tokens.
    ///
    /// - Important:
    ///     Once an access token has expired, you will need to use the refresh token to obtain a new access token and a new
    ///     refresh token. If you try to make a call with an *expired* access token, a `401` response will be returned.
    ///
    ///     You can refresh tokens via `refresh(clientID:,clientSecret:,redirectURI:,completion:)` call.
    ///
    /// - Parameters:
    ///   - code: Code retrieved from auth redirect URL.
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - redirectURI: Application’s redirect URI.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Online API Documentation**
    ///
    /// [Integrating Coinbase](https://developers.coinbase.com/docs/wallet/coinbase-connect/integrating)
    ///
    public func get(code: String,
                    clientID: String,
                    clientSecret: String,
                    redirectURI: String,
                    completion: @escaping (_ result: Result<UserToken>) -> Void) {
        let endpoint = TokensAPI.get(code: code,
                                     clientID: clientID,
                                     clientSecret: clientSecret,
                                     redirectURI: redirectURI)
        performRequest(for: endpoint) { [weak self] (result: Result<UserToken>) in
            if case .success(let userToken) = result {
                self?.setToken(userToken)
            }
            completion(result)
        }
    }

    /// Fetches a new set of access and refresh tokens.
    ///
    /// - Note:
    ///     The refresh token never expires but it can only be exchanged once for a new set of access and refresh tokens.
    ///
    /// - Parameters:
    ///   - clientID: The client ID received after registering application.
    ///   - clientSecret: The client secret received after registering application.
    ///   - refreshToken: Valid refresh token.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Online API Documentation**
    ///
    /// [Access and Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens)
    ///
    public func refresh(clientID: String,
                        clientSecret: String,
                        refreshToken: String,
                        completion: @escaping (_ result: Result<UserToken>) -> Void) {
        let endpoint = TokensAPI.refresh(clientID: clientID,
                                         clientSecret: clientSecret,
                                         refreshToken: refreshToken)
        performRequest(for: endpoint) { [weak self] (result: Result<UserToken>) in
            switch result {
            case .success(let userToken):
                self?.setToken(userToken)
            case .failure(let error):
                if case OAuthError.responseError(_, NetworkConstants.unauthorizedStatusCode) = error {
                    self?.setToken(nil)
                }
            }
            completion(result)
        }
    }

    /// Revokes access token.
    ///
    /// Access token can be revoked manually if you want to disconnect your application’s access to the user’s account.
    /// Revoking can also be used to implement a log-out feature.
    ///
    /// - Note:
    ///     Once token is successfully revoked both access token and refresh token become invalid.
    ///
    ///     To get new tokens user should pass through OAuth flow.
    ///
    /// - Parameters:
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Online API Documentation**
    ///
    /// [Access and Refresh tokens](https://developers.coinbase.com/docs/wallet/coinbase-connect/access-and-refresh-tokens)
    ///
    public func revoke(accessToken: String, completion: @escaping (_ result: Result<EmptyData>) -> Void) {
        let endpoint = TokensAPI.revoke(accessToken: accessToken)

        performRequest(for: endpoint) { [weak self] (result: Result<EmptyData>) in
            if case .success = result {
                self?.setToken(nil)
            }
            completion(result)
        }
    }
    
    // MARK: - Private Methods
    
    private func setToken(_ token: UserToken?) {
        tokenListener?.onUpdate(token: token)
    }

}

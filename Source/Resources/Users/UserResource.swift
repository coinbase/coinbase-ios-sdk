//
//  UserResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `UserResource` is a class which implements API methods for [User Resource](https://developers.coinbase.com/api/v2#users).
///
/// - Note:
///     By default, only public information is shared without any scopes.
///     More detailed information or email can be requested with additional scopes.
///
/// **See also**
///
///   `Scope.Wallet.User` constants.
///
/// **Online API Documentation**
///
/// [Users](https://developers.coinbase.com/api/v2#users),
/// [Permissions(Scopes)](https://developers.coinbase.com/docs/wallet/permissions)
///
open class UserResource: BaseResource {

    /// Fetches user's public information with their ID.
    ///
    /// - Parameters:
    ///   - id: ID of a User.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Show a user](https://developers.coinbase.com/api/v2#show-a-user)
    ///
    public func get(by id: String, completion: @escaping (_ result: Result<User>) -> Void) {
        let endpoint = UsersAPI.user(id: id)
        performRequest(for: endpoint, completion: completion)
    }

    /// Fetches current user's public information.
    ///
    /// - Important:
    ///     To get user’s email or private information, use permissions `Scope.Wallet.User.read` and `Scope.Wallet.User.email`.
    ///
    /// - Parameters:
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required for public data*
    ///   - `Scope.Wallet.User.read`
    ///   - `Scope.Wallet.User.email`
    ///
    /// **Online API Documentation**
    ///
    /// [Show current user](https://developers.coinbase.com/api/v2#show-current-user)
    ///
    public func current(completion: @escaping (_ result: Result<User>) -> Void) {
        let endpoint = UsersAPI.currentUser
        performRequest(for: endpoint, completion: completion)
    }

    /// Fetches current user’s authorization information including granted scopes and send limits when using OAuth2 authentication.
    ///
    /// - Parameters:
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    /// [Show authorization information](https://developers.coinbase.com/api/v2#show-authorization-information)
    ///
    open func authorizationInfo(completion: @escaping (_ result: Result<AuthorizationInfo>) -> Void) {
        let endpoint = UsersAPI.authorizationInfo
        performRequest(for: endpoint, completion: completion)
    }

    /// Modifies current user and their preferences.
    ///
    /// - Parameters:
    ///   - name: User’s public name.
    ///   - timeZone: Time zone.
    ///   - nativeCurrency: Local currency used to display amounts converted from BTC.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - `Scope.Wallet.User.update`
    ///
    /// **Online API Documentation**
    ///
    /// [Update current user](https://developers.coinbase.com/api/v2#update-current-user)
    ///
    public func updateCurrent(name: String? = nil,
                              timeZone: String? = nil,
                              nativeCurrency: String? = nil,
                              completion: @escaping (_ result: Result<User>) -> Void) {
        let endpoint = UsersAPI.update(name: name, timeZone: timeZone, nativeCurrency: nativeCurrency)
        performRequest(for: endpoint, completion: completion)
    }
    
}

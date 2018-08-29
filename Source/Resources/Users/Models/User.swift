//
//  User.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents generic user information.
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
/// [Permissions(Scopes)](https://developers.coinbase.com/docs/wallet/permissions)
///
open class User: Decodable {

    // MARK: - User’s public information (default)
    
    /// Resource ID.
    public let id: String
    /// User’s public name.
    public let name: String?
    /// Username.
    public let username: String?
    /// Location for user’s public profile.
    public let profileLocation: String?
    /// Bio for user’s public profile.
    public let profileBio: String?
    /// Public profile location if user has one.
    public let profileURL: String?
    /// User’s avatar url.
    public let avatarURL: String?
    /// Resource type. Constant: **"user"**.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String

    // MARK: - Information available with `wallet:user:email` scope
    
    /// Email.
    public let email: String?

    // MARK: - Information available with `wallet:user:read` scope
    
    /// User's timezone.
    public let timeZone: String?
    /// Local currency used to display amounts converted from BTC.
    public let nativeCurrency: String?
    /// Bitcoin unit.
    public let bitcoinUnit: String?
    /// User's state.
    public let state: String?
    /// User's country.
    public let country: Country?
    /// Resource creation date.
    public let createdAt: Date?
    /// Whether the user’s send functionality has been disabled.
    ///
    /// - Note:
    ///     Requires additional scopes.
    ///
    public let sendsDisabled: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case id, name, username, profileLocation, profileBio, profileURL = "profileUrl", avatarURL = "avatarUrl", resource,
        resourcePath, email, timeZone, nativeCurrency, bitcoinUnit, state, country, createdAt, sendsDisabled
    }

    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - id: Resource ID.
    ///   - name: User’s public name.
    ///   - username: Username.
    ///   - profileLocation: Location for user’s public profile.
    ///   - profileBio: Bio for user’s public profile.
    ///   - profileURL: Public profile location if user has one.
    ///   - avatarURL: User’s avatar url.
    ///   - resourcePath: Path for the location under `api.coinbase.com`.
    ///   - email: Email.
    ///   - timeZone: User's timezone.
    ///   - nativeCurrency: Local currency used to display amounts converted from BTC.
    ///   - bitcoinUnit: Bitcoin unit.
    ///   - state: User's state.
    ///   - country: User's country.
    ///   - createdAt: Resource creation date.
    ///
    internal init(id: String, name: String? = nil, username: String? = nil, profileLocation: String? = nil,
                  profileBio: String? = nil, profileURL: String? = nil, avatarURL: String? = nil, resourcePath: String,
                  email: String? = nil, timeZone: String? = nil, nativeCurrency: String? = nil, bitcoinUnit: String? = nil,
                  state: String? = nil, country: Country? = nil, createdAt: Date? = nil, sendsDisabled: Bool? = nil) {
        self.id = id
        self.name = name
        self.username = username
        self.profileLocation = profileLocation
        self.profileBio = profileBio
        self.profileURL = profileURL
        self.avatarURL = avatarURL
        self.resource = "user"
        self.resourcePath = resourcePath
        
        self.email = email
        
        self.timeZone = timeZone
        self.nativeCurrency = nativeCurrency
        self.bitcoinUnit = bitcoinUnit
        self.state = state
        self.country = country
        self.createdAt = createdAt
        self.sendsDisabled = sendsDisabled
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        profileLocation = try values.decodeIfPresent(String.self, forKey: .profileLocation)
        profileBio = try values.decodeIfPresent(String.self, forKey: .profileBio)
        profileURL = try values.decodeIfPresent(String.self, forKey: .profileURL)
        avatarURL = try values.decodeIfPresent(String.self, forKey: .avatarURL)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
        
        email = try values.decodeIfPresent(String.self, forKey: .email)
        
        timeZone = try values.decodeIfPresent(String.self, forKey: .timeZone)
        nativeCurrency = try values.decodeIfPresent(String.self, forKey: .nativeCurrency)
        bitcoinUnit = try values.decodeIfPresent(String.self, forKey: .bitcoinUnit)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        country = try values.decodeIfPresent(Country.self, forKey: .country)
        createdAt = try values.decodeIfPresent(Date.self, forKey: .createdAt)
        sendsDisabled = try values.decodeIfPresent(Bool.self, forKey: .sendsDisabled)
    }
    
}

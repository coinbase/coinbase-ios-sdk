//
//  UserToken.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Represents access token response data.
///
open class UserToken: Decodable, ConvertibleFromData {

    /// Access token.
    public let accessToken: String
    /// Access token type.
    public let tokenType: String
    /// Expiration time in seconds.
    public let expiresIn: Int
    /// Refresh token.
    public let refreshToken: String
    /// An array of scope constants.
    ///
    /// **See also**
    ///
    ///   `Scope` constants.
    ///
    public let scope: [String]
    
    private enum CodingKeys: String, CodingKey {
        case accessToken, tokenType, expiresIn, refreshToken, scope
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        accessToken = try values.decode(String.self, forKey: .accessToken)
        tokenType = try values.decode(String.self, forKey: .tokenType)
        expiresIn = try values.decode(Int.self, forKey: .expiresIn)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        
        let scopeString = try values.decode(String.self, forKey: .scope)
        scope = scopeString.components(separatedBy: " ")
    }

}

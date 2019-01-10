//
//  AuthorizationInfo.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents authorization information data.
///
open class AuthorizationInfo: Decodable {

    /// Authentication method.
    public let method: String
    /// An array of scopes.
    public let scopes: [String]
    /// Oauth meta data.
    public let oauthMeta: [String: String]
    
    private enum CodingKeys: String, CodingKey {
        case method, scopes, oauthMeta
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        method = try values.decode(String.self, forKey: .method)
        scopes = try values.decode([String].self, forKey: .scopes)
        oauthMeta = try values.decode([String: String].self, forKey: .oauthMeta)
    }

}

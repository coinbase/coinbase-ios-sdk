//
//  OAuthErrorResponse.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Represents OAuth error response model.
open class OAuthErrorResponse: Decodable {

    /// Error ID.
    public let error: String
    /// Human readable error description.
    public let description: String

    private enum CodingKeys: String, CodingKey {
        case error
        case description = "error_description"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        error = try values.decode(String.self, forKey: .error)
        description = try values.decode(String.self, forKey: .description)
    }

}

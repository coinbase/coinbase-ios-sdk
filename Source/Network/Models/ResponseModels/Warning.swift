//
//  Warning.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents warning model returned from server.
///
/// **Online API Documentation**
///
/// [Warnings](https://developers.coinbase.com/api/v2#warnings)
///
open class Warning: Decodable {

    /// Message id code.
    public let id: String
    /// Human readable message.
    public let message: String
    /// Link to the documentation.
    public let url: String?

    private enum CodingKeys: String, CodingKey {
        case id, message, url
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        message = try values.decode(String.self, forKey: .message)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

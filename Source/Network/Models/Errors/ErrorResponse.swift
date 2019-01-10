//
//  ErrorResponse.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Represents all errors returned by server.
open class ErrorResponse: Decodable {

    /// An array of error models.
    public let errors: [ErrorModel]

    private enum CodingKeys: String, CodingKey {
        case errors
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        errors = try values.decode([ErrorModel].self, forKey: .errors)
    }

}

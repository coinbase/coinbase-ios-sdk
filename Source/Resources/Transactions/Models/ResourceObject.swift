//
//  ResourceObject.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents base resource object.
///
open class ResourceObject: Decodable {
    
    /// Resource type.
    public let resource: String
    
    private enum CodingKeys: String, CodingKey {
        case resource
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        resource = try values.decode(String.self, forKey: .resource)
    }
    
}

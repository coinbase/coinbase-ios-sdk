//
//  ApplicationModel.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents OAuth2 application.
///
open class ApplicationModel: Decodable {
    
    /// Resource ID.
    public let id: String
    /// Resource type.
    public let resource: String
    /// Path for the location under `api.coinbase.com`.
    public let resourcePath: String
    /// Name.
    public let name: String?
    /// Description.
    public let description: String?
    /// Image URL.
    public let imageURL: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, resource, resourcePath, name, description, imageURL = "imageUrl"
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        resource = try values.decode(String.self, forKey: .resource)
        resourcePath = try values.decode(String.self, forKey: .resourcePath)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL)
    }
    
}

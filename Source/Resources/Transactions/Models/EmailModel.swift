//
//  EmailModel.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents sending or receiving party of a transaction which is just an email address (e.g. not a registered Coinbase user).
///
open class EmailModel: Decodable {
    
    /// Resource type. Constant: **"email"**.
    public let resource: String
    /// Email.
    public let email: String
    
    private enum CodingKeys: String, CodingKey {
        case resource, email
    }
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - email: Email.
    ///
    internal init(email: String) {
        self.resource = "email"
        self.email = email
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        resource = try values.decode(String.self, forKey: .resource)
        email = try values.decode(String.self, forKey: .email)
    }
    
}

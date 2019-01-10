//
//  Country.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents country model.
///
open class Country: Decodable {

    /// Country code abbreviation.
    public let code: String?
    /// Country name.
    public let name: String
    /// Is in Europe?
    public let isInEurope: Bool
    
    private enum CodingKeys: String, CodingKey {
        case code, name, isInEurope
    }

    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        code = try values.decodeIfPresent(String.self, forKey: .code)
        name = try values.decode(String.self, forKey: .name)
        isInEurope = try values.decode(Bool.self, forKey: .isInEurope)
    }

}

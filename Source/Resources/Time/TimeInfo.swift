//
//  TimeInfo.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents server time.
///
open class TimeInfo: Decodable {
    
    /// Time.
    public let iso: Date
    /// Time in Unix Epoch format: number of seconds elapsed from UTC 00:00:00, January 1 1970.
    public let epoch: Double
    
    private enum CodingKeys: String, CodingKey {
        case iso, epoch
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        iso = try values.decode(Date.self, forKey: .iso)
        epoch = try values.decode(Double.self, forKey: .epoch)
    }
    
}

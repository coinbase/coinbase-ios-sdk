//
//  Array+rawValues.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

// MARK: - Helper extension for Array of RawRepresentable items.

internal extension Array where Element: RawRepresentable {
    
    /// Array conatining rawValues of items.
    var rawValues: [Element.RawValue] {
        return self.map { $0.rawValue }
    }
    
}

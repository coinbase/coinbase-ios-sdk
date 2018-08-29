//
//  ConvertibleFromData.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Defines required methods to convert self from data.
public protocol ConvertibleFromData {
    
    /// Converts self from data.
    ///
    /// - Parameter data: Data.
    ///
    /// - Returns:
    ///     A new converted instance.
    ///
    /// - Throws:
    ///     Conversion related error.
    ///
    static func convert(from data: Data) throws -> Self
}

// MARK: - ConvertibleFromData extension for Data

extension Data: ConvertibleFromData {
    static public func convert(from data: Data) throws -> Data {
        return data
    }
}

// MARK: - Default implementation

public extension ConvertibleFromData where Self: Decodable {

    static public func convert(from data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let decodedObject = try decoder.decode(Self.self, from: data)

        return decodedObject
    }

}

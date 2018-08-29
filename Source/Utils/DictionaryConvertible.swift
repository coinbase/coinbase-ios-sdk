//
//  DictionaryConvertible.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// A type with Dictionary representation.
///
public protocol DictionaryConvertible {
    /// Converts to Dictionary.
    var toDictionary: [String: Any] { get }
}

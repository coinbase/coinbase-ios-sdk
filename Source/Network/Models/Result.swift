//
//  Result.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Used to represent whether a request was successful or encountered an error.
///
/// - success: The request and all post processing operations were successful.
///
/// - failure: The request encountered an error resulting a failure.
///
public enum Result<Value> {
    
    /// The request and all post processing operations were successful.
    case success(Value)
    /// The request encountered an error resulting a failure.
    case failure(Error)

    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }

    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }

    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }

    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }

    /// Maps result value with passed closure.
    ///
    /// - Parameters:
    ///     - mapper: Closure to map value if it present.
    ///      - value: Unwraped result value.
    ///
    /// - Returns:
    ///     New result object containing either result of mapping or original result's error.
    ///
    func map<NewValue>(_ mapper: (_ value: Value) -> NewValue) -> Result<NewValue> {
        switch self {
        case .success(let value):
            return .success(mapper(value))
        case .failure(let error):
            return .failure(error)
        }
    }
    
}

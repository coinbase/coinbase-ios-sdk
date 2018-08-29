//
//  State.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Possible states of Promise.
///
/// - pending: Initial state. Indicates that promise hasn’t been resolved yet.
/// - fulfilled: A promise has completed successfully.
/// - rejected: A promise has failed with the underlying error.
///
public enum State<Value> {
    
    /// Initial state. Indicates that promise hasn’t completed yet.
    ///
    /// Will transition to `fulfilled` or `rejected` state.
    case pending
    
    /// A promise has completed successfully.
    case fulfilled(Value)
    
    /// A promise has failed with the underlying error.
    case rejected(Error)
}

// MARK: - Convenience Methods

public extension State {
    
    /// `true` if promise is in initial state; otherwise, `false`.
    var isPending: Bool {
        if case .pending = self {
            return true
        } else {
            return false
        }
    }
    
    /// `true` if promise completed successfully; otherwise, `false`.
    var isFulfilled: Bool {
        if case .fulfilled = self {
            return true
        } else {
            return false
        }
    }
    
    /// `true` if promise failed; otherwise, `false`.
    var isRejected: Bool {
        if case .rejected = self {
            return true
        } else {
            return false
        }
    }
    
    /// Returns associated value if promise completed successfully; otherwise, returns `nil`.
    var value: Value? {
        if case let .fulfilled(value) = self {
            return value
        }
        return nil
    }
    
    /// Returns associated error if promise failed; otherwise, returns `nil`.
    var error: Error? {
        if case let .rejected(error) = self {
            return error
        }
        return nil
    }
    
}

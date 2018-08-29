//
//  Callback.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents model with two closures and queue to call these closures on.
internal struct Callback<Value> {
    /// Closure to call in case of success.
    let onFulfill: (Value) -> Void
    /// Closure to call in case of reject.
    let onReject: (Error) -> Void
    /// Queue to call closures on.
    let queue: DispatchQueue
}

// MARK: - Helper Methods for Callback

internal extension Callback {
    
    /// Calls `onFullfil` with the provided value asynchronously in a dedicated queue.
    ///
    /// - Parameter value: Provided value.
    ///
    func callFulfill(_ value: Value) {
        queue.async {
            self.onFulfill(value)
        }
    }
    
    /// Calls `onReject` with the provided error asynchronously in a dedicated queue.
    ///
    /// - Parameter error: Provided error.
    ///
    func callReject(_ error: Error) {
        queue.async {
            self.onReject(error)
        }
    }
    
}

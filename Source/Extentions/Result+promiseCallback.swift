//
//  Result+PromiseCallback.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

// MARK: - Helper extension to connect  handler.

internal extension Result {
    
    /// Converts `onSuccess` and `onFailure` completion closures into completion handler expecting `Result<Value>`.
    ///
    /// - Parameters:
    ///   - onSuccess: Closure which should be called in case of success.
    ///    - value: Value from succeeded result.
    ///   - onFailure: Closure which should be called in case of failure.
    ///    - error: Error from failed result.
    ///
    /// - Returns:
    ///     Closure expecting `Result<Value>`.
    ///
    static func completeResult(_ onSuccess: @escaping (_ value: Value) -> Void,
                               _ onFailure: @escaping (_ error: Error) -> Void ) -> ((Result<Value>) -> Void) {
        return { result in
            switch result {
            case .success(let value): onSuccess(value)
            case .failure(let error): onFailure(error)
            }
        }
    }
    
}

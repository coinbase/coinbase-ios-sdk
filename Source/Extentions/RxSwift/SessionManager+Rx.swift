//
//  Request+RxSwift.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for Session Manager.

extension SessionManager {
    
    /// Generates completion closure from with `SingleObserver`
    ///
    /// - Parameters:
    ///     - single: `SingleObserver`
    ///      - event: `SingleEvent`
    ///
    public static func completion<T>(with single: @escaping (_ event: SingleEvent<T>) -> Void) -> ((Result<T>) -> Void) {
        return { result in
            switch result {
            case let .success(data): single(.success(data))
            case let .failure(error): single(.error(error))
            }
        }
    }
    
}

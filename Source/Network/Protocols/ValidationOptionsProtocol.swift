//
//  ValidationOptions.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Error response type definitions.
///
/// - oauth: Error response will follow [oauth error](https://developers.coinbase.com/docs/wallet/error-codes) format.
/// - general: Error response will follow [general error](https://developers.coinbase.com/api/v2#errors) format.
///
public enum ErrorResponseType {
    /// Error response will follow [oauth error](https://developers.coinbase.com/docs/wallet/error-codes) format.
    case oauth
    /// Error response will follow [general error](https://developers.coinbase.com/api/v2#errors) format.
    case general
}

/// Defines required options to validate response.
public protocol ValidationOptionsProtocol {
    /// Error response type.
    ///
    /// Default value is `ErrorResponseType.general`.
    var errorResponseType: ErrorResponseType { get }

    /// Defines if response is allowed to be empty.
    ///
    /// Default value is `false`.
    var allowEmptyResponse: Bool { get }
}

// MARK: - Default implementation for ValidationOptionsProtocol

extension ValidationOptionsProtocol {

    public var errorResponseType: ErrorResponseType {
        return .general
    }

    public var allowEmptyResponse: Bool {
        return false
    }

}

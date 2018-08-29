//
//  Errors.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Error type returned by Coinbase Network Layer.
public enum NetworkError: Error {
    /// Returned when base url is invalid.
    case invalidBaseURL(String)
    /// Returned when request's path is invalid.
    case invalidEnvironmentData(URLComponents)
    /// Returned when access token is empty for request which requires authentication.
    case emptyAccessToken(URLRequest)
    /// Returned when the SDK tries to perform token refresh and refresh token is empty.
    case emptyRefreshToken
    /// Returned when serever responed with error.
    case responseError(ErrorResponse, statusCode: Int)
}

/// Error type returned by SDK serialization layer.
public enum ResponseSerializationError: Error {
    /// The response type is incorrect.
    case incorrectResponseType
    /// The response status code is not acceptable.
    case unacceptableStatusCode(Int)
    /// The response contains no data or the data is zero length.
    case inputDataEmpty
}

/// MARK: - Localized descriptions for error types

extension NetworkError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .invalidBaseURL(let url):
            return "Invalid base URL: \"\(url)\""
        case .invalidEnvironmentData(let components):
            return "Invalid environment data. Can't create URL from components:\n\(components)"
        case .emptyAccessToken(let request):
            return "Access Token is empty. Request requires authentication: \(request)"
        case .emptyRefreshToken:
            return "Refresh token is empty in attempt to perorm refresh tokens."
        case .responseError(_, let statusCode):
            return "Serever responed with Error. Status code: \(statusCode)"
        }
    }

}

extension ResponseSerializationError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .incorrectResponseType:
            return "The response type is incorrect."
        case .unacceptableStatusCode(let code):
            return "Response status code is not acceptable: \(code)."
        case .inputDataEmpty:
            return "Response could not be serialized, input data is nil or zero length."
        }
    }

}

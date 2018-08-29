//
//  OAuthError.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Error type returned by Coinbase OAuth.
///
public enum OAuthError: Error {
    /// OAuth misses required parameter which should be set in `setup` method.
    case configurationMissing
    /// URIs are not valid. URI scheme is missing.
    case invalidURIs(uris: Set<String>)
    /// URI schemes are not registered as a URL scheme.
    case notRegisteredSchemes(schemes: Set<String>)
    /// URLOpener returned false for `canOpenURL` method.
    case cantRedirectTo(url: URL?)
    /// Received URL doesn't match required pattern.
    case cantHandleURL(url: URL)
    /// Received URL doesn't have any query parameters.
    case malformedResponse(url: URL)
    /// Received CSRF parameter `state` doesn't match the one which has been sent.
    case incorrectStateParameterInResponse(state: String?, expectedState: String?)
    /// Received URL doesn't have an authorization code parameter.
    case missingCodeParameterInResponse(url: URL)
    /// The attempt to perform OAuth request failed with underlying response error.
    case responseError(OAuthErrorResponse, statusCode: Int)
}

extension OAuthError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .configurationMissing:
            return "OAuth misses required parameter which should be set in `setup` method."
        case .invalidURIs(let uris):
            let urisString = "\"\(uris.joined(separator: "\", \""))\""
            return "URI scheme is missing in: \(urisString)"
        case .notRegisteredSchemes(let schemes):
            let schemesString = "\"\(schemes.joined(separator: "\", \""))\""
            return "URI scheme is not registered for: \(schemesString)"
        case .cantRedirectTo(let url):
            return "URLOpener returned false for `canOpenURL` method for URL: \(url?.absoluteString ?? "nil")"
        case .cantHandleURL(let url):
            return "Received URL doesn't match required pattern. URL: \(url)"
        case .malformedResponse(let url):
            return "Redirect URL doesn't have any query parameters.\nURL: \(url.absoluteString)"
        case .incorrectStateParameterInResponse(let state, let expectedState):
            return "Received CSRF parameter `state` doesn't match the one which has been sent." +
            "\nState: \"\(state ?? "")\", expected: \"\(expectedState ?? "")\""
        case .missingCodeParameterInResponse(let url):
            return "Received URL doesn't have an authorization code parameter.\nURL: \(url.absoluteString)"
        case .responseError(let error, let statusCode):
            return "The attempt to perform OAuth request failed with error:\nError: \"\(error.error)\"\nDescription: \"\(error.description)\"\nStatus Code: \(statusCode)"
        }
    }
    
}

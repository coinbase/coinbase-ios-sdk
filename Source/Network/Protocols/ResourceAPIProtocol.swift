//
//  ResourceAPI.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Authentication type definitions.
///
/// - none: Authentication is not required.
/// - token: Authentication with an access token.
///
public enum AuthenticationType {
    /// Authentication is not required.
    case none
    /// Authentication with an access token.
    case token
}

/// HTTP request methods.
public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

/// Parameters to pass along with the request.
///
/// - body: Parameters to send in the body of the request message.
/// - get: Parameters to send as URL query parameter of the request message.
public enum RequestParameters {
    /// Parameters to send in the body of the request message.
    case body(_ : [String: Any])
    /// Parameters to send as URL query parameter of the request message.
    case get(_ : [String: String])
}

/// Defines required parameters to create and validate all API requests.
public protocol ResourceAPIProtocol: ValidationOptionsProtocol, RequestConvertible {
    /// Relative path of the endpoint (i.e. `"/user/auth"`).
    var path: String { get }

    /// The HTTP request method.
    var method: HTTPMethod { get }

    /// Parameters to send along with the call.
    var parameters: RequestParameters? { get }

    /// A dictionary containing *additional* HTTP header fields required for the specific endpoint.
    ///
    /// Default value is *empty* dictionary.
    var headers: [String: String] { get }

    /// Authentication type for request.
    ///
    /// Default value is `AuthenticationType.none`
    var authentication: AuthenticationType { get }
    
    /// Array of fields to expand.
    ///
    /// **Online API Documentation**
    ///
    /// [Expanding resources](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    var expandOptions: [String] { get }
}

// MARK: - Default implementation for ResourceAPIProtocol

extension ResourceAPIProtocol {
    
    public var headers: [String: String] {
        return [:]
    }
    
    public var authentication: AuthenticationType {
        return .none
    }
    
    public var expandOptions: [String] {
        return []
    }
    
}

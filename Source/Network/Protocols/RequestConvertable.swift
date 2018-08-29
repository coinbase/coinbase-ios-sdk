//
//  RequestConvertible.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// A type with URLRequest representation.
public protocol RequestConvertible {

    /// Converts to URLRequest.
    ///
    /// - Parameter baseURL: base url for request (i.e. `"https://api.coinbase.com"`).
    /// - Returns:
    ///     Valid request.
    /// - Throws:
    ///     Error in case convertion was failed.
    ///
    func asURLRequest(baseURL: String) throws -> URLRequest

}

// MARK: - Default implementation for RequestConvertible conforming to ResourceAPIProtocol

extension RequestConvertible where Self: ResourceAPIProtocol {

    /// Converts to URLRequest.
    ///
    /// - Parameter baseURL: base url for request (i.e. `"https://api.coinbase.com"`).
    /// - Returns:
    ///     Valid request.
    /// - Throws:
    ///     - `NetworkError.invalidBaseURL()` - when `URLComponents` can't be created with provided `baseURL`.
    ///     - `JSONSerialization` Error - when `RequestParameters.body()` parameters failed to serialize.
    ///     - `NetworkError.invalidEnvironmentData()` - when `URL` can't be created with provided parameters.
    ///
    public func asURLRequest(baseURL: String) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw NetworkError.invalidBaseURL(baseURL)
        }
        
        urlComponents.path += path
        
        var httpBody: Data?
        
        // Working with parameters
        switch parameters {
        case .some(.body(let parameters)):
            // Parameters are part of the body
            httpBody = try JSONSerialization.data(withJSONObject: parameters)
        case .some(.get(let parameters)):
            // Parameters are part of the url
            let queryParameters = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            urlComponents.queryItems = queryParameters
        default: break
        }
        
        if !expandOptions.isEmpty {
            let queryItems = urlComponents.queryItems ?? []
            let expandQueryItems = expandOptions.map { URLQueryItem(name: "expand[]", value: $0) }
            
            let joinedQueryItems = queryItems + expandQueryItems
            
            urlComponents.queryItems = joinedQueryItems
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidEnvironmentData(urlComponents)
        }
        
        var request = URLRequest(url: url)
        request.httpBody = httpBody
        
        // Join headers from enviornment and request
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        // Setup HTTP method
        request.httpMethod = method.rawValue
        
        return request
    }

}

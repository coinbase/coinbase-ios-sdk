//
//  Response.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Used to store all data associated with a serialized response.
public class Response<Value>: DefaultResponse {
    
    /// The result of response serialization.
    public let result: Result<Value>

    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///     - request: The URL request sent to the server.
    ///     - response: The server's response to the URL request.
    ///     - data: The data returned by the server.
    ///     - result: The result of response serialization.
    ///
    public init(request: URLRequest?,
                response: HTTPURLResponse?,
                data: Data?,
                result: Result<Value>) {
        self.result = result
        
        super.init(request: request, response: response, data: data, error: result.error)
    }
    
}

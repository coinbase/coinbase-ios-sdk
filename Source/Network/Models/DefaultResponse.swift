//
//  DefaultResponse.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Used to store all data associated with an non-serialized response of a request.
public class DefaultResponse {
    
    /// The URL request sent to the server.
    public let request: URLRequest?

    /// The server's response to the URL request.
    public let response: HTTPURLResponse?

    /// The data returned by the server.
    public let data: Data?

    /// The error encountered while executing or validating the request.
    public let error: Error?

    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - request: The URL request sent to the server.
    ///   - response: The server's response to the URL request.
    ///   - data: The data returned by the server.
    ///   - error: The error encountered while executing or validating the request.
    ///
    public init(request: URLRequest?,
                response: HTTPURLResponse?,
                data: Data?,
                error: Error?) {
        self.request = request
        self.response = response
        self.data = data
        self.error = error
    }
}

// MARK: - Validation

extension DefaultResponse {

    /// Checks if response contains an error, status code is valid
    /// and response is not empty in case it's not allowed.
    internal func validate(options: ValidationOptionsProtocol) throws {
        guard error == nil else {
            throw error!
        }
        guard let statusCode = response?.statusCode else {
            throw ResponseSerializationError.incorrectResponseType
        }
        
        if !options.allowEmptyResponse {
            try checkEmptyResponse(statusCode: statusCode)
        }
        
        if !NetworkConstants.validStatusCodes.contains(statusCode) {
            throw parseResponseError(type: options.errorResponseType,
                                     statusCode: statusCode)
        }
    }
    
    // MARK: - Private Methodws

    private func checkEmptyResponse(statusCode: Int) throws {
        if NetworkConstants.emptyDataStatusCodes.contains(statusCode) || data?.isEmpty ?? true {
            throw ResponseSerializationError.inputDataEmpty
        }
    }
    
    private func parseResponseError(type: ErrorResponseType, statusCode: Int) -> Error {
        guard let data = data, !data.isEmpty else {
            return ResponseSerializationError.unacceptableStatusCode(statusCode)
        }
        switch type {
        case .oauth:
            if let error = try? JSONDecoder().decode(OAuthErrorResponse.self, from: data) {
                return OAuthError.responseError(error, statusCode: statusCode)
            }
        case .general:
            if let error = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                return NetworkError.responseError(error, statusCode: statusCode)
            }
        }
        return ResponseSerializationError.unacceptableStatusCode(statusCode)
    }
    
}

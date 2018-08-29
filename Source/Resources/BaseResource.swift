//
//  BaseResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Base class which provides methods to perform requests using provided Session Manager and Base URL.
open class BaseResource {

    private let sessionManager: SessionManagerProtocol
    private let baseURL: String

    /// Initialize BaseResource with `sessionManager` and `baseURL`.
    ///
    /// - Parameters:
    ///   - sessionManager: Instance of `SessionManagerProtocol` used to perform request.
    ///   - baseURL: Base URL which is used as **default** base URL for current resource requests.
    ///
    public init(sessionManager: SessionManagerProtocol, baseURL: String) {
        self.sessionManager = sessionManager
        self.baseURL = baseURL
    }

    /// Performs request in case where requested model **conforms** to both `ConvertibleFromData` and `Decodable` protocols.
    ///
    /// - Important: T confroms to `ConvertibleFromData`.
    ///
    /// - Parameters:
    ///   - resourceAPI: Instance of type defining required parameters to create and validate request.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     This completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    open func performRequest<T>(for resourceAPI: ResourceAPIProtocol,
                                completion: @escaping (_ result: Result<T>) -> Void) where T: ConvertibleFromData, T: Decodable {
        // Calling request method for ConvertibleFromData resources
        sessionManager.request(resourceAPI, baseURL: self.baseURL, completion: completion)
    }

    /// Performs request in case where requested model **does NOT conform** to `ConvertibleFromData` and **conforms** to `Decodable` protocols.
    ///
    /// - Important: T does **NOT** confrom to `ConvertibleFromData`.
    ///
    /// - Parameters:
    ///   - resourceAPI: Instance of type defining required parameters to create and validate request.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     This completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    open func performRequest<T>(for resourceAPI: ResourceAPIProtocol,
                                completion: @escaping (_ result: Result<T>) -> Void) where T: Decodable {
        // Calling request method for ConvertibleFromData resources
        performRequest(for: resourceAPI) { (result: Result<ResponseModel<T>>) in
            result.value?.warnings?.forEach {
                log($0.log(with: resourceAPI), category: .warning)
            }
            completion(result.map { $0.data })
        }
    }

}

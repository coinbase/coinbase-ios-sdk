//
//  SessionManager.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Implementation for `SessionManagerProtocol`.
public class SessionManager: SessionManagerProtocol, URLSessionProviderProtocol {
    
    /// The underlying session.
    internal let session: URLSession
    
    public var accessTokenProvider: AccessTokenProvider?
    
    public var interceptors: [RequestPromiseInterceptor] = []
    
    // MARK: - Lifecycle
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - configuration: The configuration used to construct the managed session.
    ///                    `URLSessionConfiguration.default` by default.
    ///   - sessionHeaders: A dictionary with additional headers.
    ///
    ///     **Note**
    ///
    ///      Default headers of the SDK have superior priority over headers provided throuh `sessionHeaders`.
    ///
    public init(configuration: URLSessionConfiguration = .default,
                sessionHeaders: [String: Any]? = nil) {
        var additionalHeader = NetworkUtils.defaultHTTPHeaders
        if let sessionHeaders = sessionHeaders {
            // Merge default headers with additional headers if exist. Overwriting default header keys is NOT allowed.
            additionalHeader = additionalHeader.merging(sessionHeaders, uniquingKeysWith: { (first, _) in first })
        }
        configuration.httpAdditionalHeaders = additionalHeader
        
        let cacheMemorySize = 4 * 1024 * 1024 // 4 MB
        configuration.urlCache = URLCache(memoryCapacity: cacheMemorySize, diskCapacity: 0, diskPath: nil)
        configuration.requestCachePolicy = .useProtocolCachePolicy
        
        let serverTrustValidator = ServerTrustValidator(pinnedCertificates: ServerTrustValidator.certificates(in: Bundle(for: SessionManager.self)))
        session = URLSession(configuration: configuration,
                             delegate: SessionDelegate(serverTrustValidator: serverTrustValidator),
                             delegateQueue: nil)
    }
    
    // MARK: - Data Request
    
    /// Creates a request and handles it's response.
    ///
    /// After request is created and performed, it gets checked according to the validation
    /// options defined in provided `resourceAPI` parameter. Then it gets decoded to the type
    /// provided in `type` parameter.
    ///
    /// - Parameters:
    ///   - resourceAPI: Description of required parameters to create and request.
    ///   - baseURL: Base url for request.
    ///   - type: Type of the model that should be returned.
    ///
    /// - Returns:
    ///     New `Promise` with handled response.
    ///
    public func request<T>(_ resourceAPI: ResourceAPIProtocol, baseURL: String, type: T.Type) -> Promise<Response<T>> where T: ConvertibleFromData {
        let request = Promise<Any>
            .createRequest(from: resourceAPI, baseURL: baseURL, accessToken: accessTokenProvider?.accessToken)
            .performRequest(sessionProvider: self)
            .validate(options: resourceAPI)
            .convert(to: T.self)
        return interceptors.reduce(request, { promise, interceptor in
            interceptor.intersept(promise: promise, for: resourceAPI, baseURL: baseURL)
        })
    }
    
    public func request<T>(_ resourceAPI: ResourceAPIProtocol,
                           baseURL: String,
                           completion: @escaping (_ result: Result<T>) -> Void) where T: ConvertibleFromData {
        log("Resource(Request): \(resourceAPI.nameDiscription)")
        request(resourceAPI, baseURL: baseURL, type: T.self)
            .then { response -> Void in
                completion(response.result)
            }
            .catch({ error -> Void in
                log("Resource(Error): \(resourceAPI.logDiscription) Error:\n\(error)", category: .error)
                completion(.failure(error))
            })
    }
    
    deinit {
        // Clear cache to avoid memory leaks
        session.configuration.urlCache?.removeAllCachedResponses()
        // Invalide session to free its delegate and captured resources to avoid leaks
        session.finishTasksAndInvalidate()
    }
    
}

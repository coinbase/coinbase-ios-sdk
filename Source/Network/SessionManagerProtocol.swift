//
//  SessionManagerProtocol.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Defines required methods to provide interceptor mechanism.
///
/// Interceptors provides the way to append an action to request's postprocessing to perform aditional
/// logic before responce is returned to the caller.
///
public protocol RequestPromiseInterceptor {
    
    /// Defines logic that will be performed before responce is returned to the caller.
    ///
    /// - Parameters:
    ///   - promise: `Promise` with handled response.
    ///   - resourceAPI: Instance of ResourceAPIProtocol containing original request's parameters.
    ///   - baseURL: Original request's base url.
    ///
    /// - Returns:
    ///     `Promise` with responce.
    ///
    ///     Interceptor can return orginal promise, modified origignal promise or
    ///     create a new promise.
    ///
    func intersept<T>(promise: Promise<Response<T>>, for resourceAPI: ResourceAPIProtocol, baseURL: String) -> Promise<Response<T>> where T: ConvertibleFromData
}

/// Defines required methods and fields to create and perfom requests which is described by `ResourceAPIProtocol`.
public protocol SessionManagerProtocol: class {
    
    /// Creates a request and handles it's response.
    ///
    /// - Parameters:
    ///   - resourceAPI: Description of required parameters to create and request.
    ///   - baseURL: Base url for request.
    ///   - type: Type of the model that should be returned.
    ///
    /// - Returns:
    ///     New `Promise` with handled response.
    ///
    func request<T>(_ resourceAPI: ResourceAPIProtocol, baseURL: String, type: T.Type) -> Promise<Response<T>> where T: ConvertibleFromData
    
    /// Creates a request and handles it's response.
    ///
    /// - Note:
    ///     This method is a convinience method for `request(baseURL:type:)` allowing to
    ///     handle asynchronous calls using approach with completion closure.
    ///
    /// - Parameters:
    ///   - resourceAPI: Description of required parameters to create and request.
    ///   - baseURL: Base url for request.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     This completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    func request<T>(_ resourceAPI: ResourceAPIProtocol, baseURL: String, completion: @escaping (_ result: Result<T>) -> Void) where T: ConvertibleFromData
    
    /// Access token provider which provides valid access token for requests requiring authorization.
    var accessTokenProvider: AccessTokenProvider? { get set }
    
    /// An array of interceptors that will be used after default request's postprocessing steps.
    ///
    /// - Note:
    ///     Interceptors are chained one after another.
    ///
    var interceptors: [RequestPromiseInterceptor] { get set }
    
}

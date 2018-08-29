//
//  NetworkPromises.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

// MARK: - Request Creation

internal extension Promise {

    /// Creates a new `Promise` that creates an `URLRequest`.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke created promise on.
    ///   - resourceAPI: Description of required parameters to create and request.
    ///   - baseURL: Base url for request.
    ///   - accessToken: Access token for requests requiring authorization.
    ///
    /// - Returns:
    ///     A new `Promise` that creates an `URLRequest`.
    ///
    static func createRequest(on queue: DispatchQueue = DispatchQueue.main,
                              from resourceAPI: ResourceAPIProtocol,
                              baseURL: String,
                              accessToken: String? = nil) -> Promise<URLRequest> {
        let promise = Promise<URLRequest>(queue: queue) { fulfill, reject in
            do {
                var request = try resourceAPI.asURLRequest(baseURL: baseURL)

                if resourceAPI.authentication == .token {
                    guard let accessToken = accessToken, !accessToken.isEmpty else {
                        throw NetworkError.emptyAccessToken(request)
                    }
                    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: HeaderKeys.authorization)
                }
                fulfill(request)
            } catch {
                reject(error)
            }
        }
        return promise
    }

}

// MARK: - Request Performing

internal extension Promise where Value == URLRequest {

    /// Creates a new `Promise` that performs `URLRequest` provided by current promise.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke created promise on.
    ///   - sessionProvider: `URLSession` provider.
    ///
    /// - Returns:
    ///     A new `Promise` that performs `URLRequest` provided by current promise.
    ///
    @discardableResult
    func performRequest(on queue: DispatchQueue = DispatchQueue.main, sessionProvider: URLSessionProviderProtocol) -> Promise<DefaultResponse> {
        return then(on: queue, { request -> Promise<DefaultResponse> in
            let promise = Promise<DefaultResponse>(queue: queue) { fulfill, _ in
                log("Request(Fire): \(request.logDiscription)")
                sessionProvider.session.dataTask(with: request) { data, response, error in
                    let dataResponse = DefaultResponse(request: request,
                                                       response: response as? HTTPURLResponse,
                                                       data: data, error: error)
                    log("Request(Recive response): \(request.logDiscription)")
                    DispatchQueue.main.async {
                        fulfill(dataResponse)
                    }
                    }.resume()
            }
            return promise
        })
    }

}

// MARK: - Response Methods

internal extension Promise where Value == DefaultResponse {
    
    /// Creates a new `Promise` that checks if response contains an error, validates status code and empty response if needed.
    ///
    /// - Parameters:
    ///   - queue: A queue to invoke created promise on.
    ///   - options: Responce validation options.
    ///
    /// - Returns:
    ///     A new `Promise` that performs validation of response provided by current promise.
    ///
    @discardableResult
    func validate(on queue: DispatchQueue = DispatchQueue.main, options: ValidationOptionsProtocol) -> Promise<DefaultResponse> {
        return then(on: queue, { response -> Promise<DefaultResponse> in
            log("Request(Validate response): \(response.request?.logDiscription ?? "")")
            try response.validate(options: options)
            
            return Promise<DefaultResponse>(value: response)
        })
    }
    
    /// Creates a new `Promise` that converts the default response to the type specified in `type` parameter.
    ///
    /// - Parameters:
    ///   - queue: Queue on which parsing will be evaluated.
    ///   - type: The model type, from which the response will be parsed.
    ///
    /// - Returns:
    ///     New `Promise` instance with parsed response.
    ///
    @discardableResult
    func convert<T>(on queue: DispatchQueue = DispatchQueue.main, to type: T.Type) -> Promise<Response<T>> where T: ConvertibleFromData {
        return then(on: queue, { (response) -> Promise<Response<T>> in
            var result: Result<T>
            if let data = response.data {
                log("Request(Map to \(T.self) ): \(response.request?.logDiscription ?? "")")
                let resultValue = try T.self.convert(from: data)
                log("Request(Recive model): \(response.request?.logDiscription ?? "") model:\n\(resultValue)", category: .info)
                result = .success(resultValue)
            } else {
                result = .failure(ResponseSerializationError.incorrectResponseType)
            }
            
            let newResponse = Response(request: response.request,
                                       response: response.response,
                                       data: response.data,
                                       result: result)
            return Promise<Response<T>>(value: newResponse)
        })
    }
    
}

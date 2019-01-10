//
//  TokenRefreshInterceptor.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Foundation
import Dispatch

/// Defines data required for TokenAutoRefreshInterceptor.
internal protocol TokenRefreshDataProviderProtocol: class {
    
    /// The client ID received after registering application.
    var clientID: String { get }
    /// The client secret received after registering application.
    var clientSecret: String { get }
    /// Token which can be used to refresh expired access token.
    var refreshToken: String { get }
    /// Closure which gets called on every token update.
    var onTokenUpdate: ((UserToken?) -> Void)? { get }
    
}

/// Interceptor to perform Token Refresh in case of `expiredToken` error.
///
internal class TokenAutoRefreshInterceptor: RequestPromiseInterceptor {
    
    private weak var sessionManager: SessionManagerProtocol?
    private weak var tokenResource: TokenResource?
    private let dataProvider: TokenRefreshDataProviderProtocol
    
    private let refreshQueue = DispatchQueue(label: "com.coinbase.ios.sdk." + UUID().uuidString)
    private let refreshSemaphore = DispatchSemaphore(value: 1)
    
    internal init(sessionManager: SessionManagerProtocol, tokenResource: TokenResource, dataProvider: TokenRefreshDataProviderProtocol) {
        self.sessionManager = sessionManager
        self.tokenResource = tokenResource
        self.dataProvider = dataProvider
    }
    
    internal func intersept<T>(promise: Promise<Response<T>>,
                               for resourceAPI: ResourceAPIProtocol,
                               baseURL: String) -> Promise<Response<T>> where T: ConvertibleFromData {
        return promise.recover { error in
            try self.handle(error: error, to: resourceAPI, baseURL: baseURL)
        }
    }
    
    private func handle<T>(error: Error, to resourceAPI: ResourceAPIProtocol, baseURL: String) throws -> Promise<Response<T>> where T: ConvertibleFromData {
        guard case NetworkError.responseError(_, NetworkConstants.unauthorizedStatusCode) = error,
            type(of: resourceAPI) != TokensAPI.self,
            let sessionManager = sessionManager else {
                throw error
        }
        return syncedRefreshPromise()
            .then({ _ in
                return sessionManager.request(resourceAPI, baseURL: baseURL, type: T.self)
            })
    }
    
    private func syncedRefreshPromise() -> Promise<Void> {
        let refreshTokenBeforeWaiting = dataProvider.refreshToken
        
        return wait(queue: refreshQueue, for: refreshSemaphore)
            .then({ _ -> Promise<Void> in
                // check if token changed during wating
                guard refreshTokenBeforeWaiting == self.dataProvider.refreshToken else {
                    self.refreshSemaphore.signal()
                    return Promise(value: Void())
                }
                return self.refreshPromise(with: refreshTokenBeforeWaiting)
                    .then({ _ in Void() })
                    .finally({ self.refreshSemaphore.signal() })
            })
    }
    
    private func refreshPromise(with refreshToken: String) -> Promise<UserToken> {
        return Promise { fulfill, reject in
            self.tokenResource?.refresh(clientID: self.dataProvider.clientID,
                                        clientSecret: self.dataProvider.clientSecret,
                                        refreshToken: refreshToken,
                                        completion: Result.completeResult(fulfill, reject))
        }
    }
    
}

private func wait(queue: DispatchQueue, for semaphore: DispatchSemaphore) -> Promise<Void> {
    return Promise(queue: queue) { (fulfill, _) in
        semaphore.wait()
        fulfill(Void())
    }
}

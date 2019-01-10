//
//  MockedSessionManager.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK

class MockedSessionManager: SessionManagerProtocol {
    
    var interceptors: [RequestPromiseInterceptor] = []
    var accessTokenProvider: AccessTokenProvider?
    var lastRequest: ResourceAPIProtocol?
    
    func request<T>(_ resourceAPI: ResourceAPIProtocol,
                    baseURL: String,
                    completion: @escaping (Result<T>) -> Void) where T: ConvertibleFromData {
        lastRequest = resourceAPI
    }
    
    func request<T>(_ resourceAPI: ResourceAPIProtocol, baseURL: String, type: T.Type) -> Promise<Response<T>> where T: ConvertibleFromData {
        return Promise(error: NSError(domain: "ds", code: 0, userInfo: nil))
    }
    
}

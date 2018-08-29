//
//  SessionDelegate.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 
import Foundation

/// Implementaion for URLSessionDataDelegate protocol.
///
/// It controls URLSession's Cache policy and allows to pin SSL certificate.
///
internal class SessionDelegate: NSObject, URLSessionDataDelegate {
    
    private let serverTrustValidator: ServerTrustValidator?
    
    internal init(serverTrustValidator: ServerTrustValidator? = nil) {
        self.serverTrustValidator = serverTrustValidator
        super.init()
    }
    
    // MARK: - URLSessionDataDelegate Methods
    
    internal func urlSession(_ session: URLSession,
                             dataTask: URLSessionDataTask,
                             willCacheResponse proposedResponse: CachedURLResponse,
                             completionHandler: @escaping (CachedURLResponse?) -> Void) {
        completionHandler(CachedURLResponse(response: proposedResponse.response,
                                            data: proposedResponse.data,
                                            userInfo: proposedResponse.userInfo,
                                            storagePolicy: .allowedInMemoryOnly))
    }
    
    internal func urlSession(_ session: URLSession,
                             didReceive challenge: URLAuthenticationChallenge,
                             completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrustValidator = serverTrustValidator,
            challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust else {
                completionHandler(.performDefaultHandling, nil)
                return
        }
        
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        let host = challenge.protectionSpace.host
        
        if serverTrustValidator.evaluate(serverTrust, forHost: host) {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
    
}

//
//  RedirectURIsValidator.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Represents url schemes validator which checks if URI scheme is registered for current application.
struct RedirectURIsValidator: RedirectURIsValidatorProtocol {
    let bundle = Bundle.main
}

protocol RedirectURIsValidatorProtocol {
    
    /// Bundle where registered schemes should be checked.
    var bundle: Bundle { get }
    
    /// Checks if provided URIs are valid and their schemes are registered.
    ///
    /// - Parameter uris: An array of URIs to validate.
    /// - Throws: An `OAuthError` if at least one URI is not valid.
    ///
    func validate(_ redirectURIs: [String]) throws
    
}

// MARK: - Default implementation of RedirectURIsValidatorProtocol

extension RedirectURIsValidatorProtocol {
    
    func validate(_ redirectURIs: [String]) throws {
        let (redirectSchemes, invalidURIs) = redirectURIs.reduce(([], [])) { (result, uri) -> (Set<String>, Set<String>) in
            var (schemes, invalidURIs) = result
            if let uriScheme = URL(string: uri)?.scheme {
                schemes.insert(uriScheme)
            } else {
                invalidURIs.insert(uri)
            }
            return (schemes, invalidURIs)
        }
        guard invalidURIs.isEmpty else {
            throw OAuthError.invalidURIs(uris: invalidURIs)
        }
        
        let registeredSchemes = Set(registeredURLSchemes())
        let unregisteredSchemes = redirectSchemes.subtracting(registeredSchemes)
        if !unregisteredSchemes.isEmpty {
            throw OAuthError.notRegisteredSchemes(schemes: unregisteredSchemes)
        }
    }
    
    /// Gets an array of registered schemes in provided Bundle.
    ///
    /// - Returns: An array of registered URL schemes in provided Bundle.
    ///
    func registeredURLSchemes() -> [String] {
        guard let urlTypes = bundle.infoDictionary?["CFBundleURLTypes"] as? [[String: AnyObject]] else {
            return []
        }
        return urlTypes.flatMap { $0["CFBundleURLSchemes"] as? [String] ?? [] }
    }
    
}

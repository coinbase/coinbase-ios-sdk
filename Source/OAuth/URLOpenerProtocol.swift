//
//  URLOpenerProtocol.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Defines required functions to check and open URLs.
public protocol URLOpenerProtocol {
    
    /// Returns a Boolean value indicating whether or not the URL can be handled.
    ///
    /// - Parameter url: A URL (Universal Resource Locator) to check.
    /// - Returns: `false` if URL can't be handled; otherwise, `true`.
    ///
    func canOpenURL(_ url: URL) -> Bool
    
    /// Open the resource at the specified URL.
    ///
    /// - Parameters:
    ///   - url: A URL (Universal Resource Locator) to open.
    ///   - options: A dictionary of options to use when opening the URL.
    ///         For a list of possible keys to include in this dictionary, see *URL Options*.
    ///   - completion: The block to execute with the results.
    ///
    ///       The block has no return value and takes a Boolean parameter indicating whether the URL was opened successfully.
    ///
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)

}

#if os(iOS)
extension UIApplication: URLOpenerProtocol {}
#endif

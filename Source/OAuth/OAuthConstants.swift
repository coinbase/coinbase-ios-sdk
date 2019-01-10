//
//  OAuthConstants.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// OAuth related constants.
internal struct OAuthConstants {

    /// Length of default generated `state` parameter.
    static let defaultStateLength = 8

    /// Authorization URL related constants.
    struct AuthorizationURL {
        static let scheme = "https"
        static let host = "www.coinbase.com"
        static let path = "/oauth/authorize"
    }

}

/// Layout related constants.
///
/// For logged out users, it is recommended to shown log in page.
/// You can show the sign up page instead.
///
public struct Layout {
    
    /// Show the sign up page.
    public static let signup = "signup"
    
}

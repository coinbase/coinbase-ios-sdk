//
//  Constants.swift
//  iOS Example
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation
import UIKit

struct OAuth2ApplicationKeys {
    
    /// The client ID received after registering application. Should be provided to use sample app.
    static let clientID = ""
    /// The client secret received after registering application. Should be provided to use sample app.
    static let clientSecret = ""
    /// Application’s redirect URI. Should be provided to use sample app.
    static let redirectURI = ""
    /// Application’s verification deeplink URI. Optional.
    static let deeplinkURI = ""
    
    static var isConfigured: Bool {
        return !(clientID.isEmpty || clientSecret.isEmpty || redirectURI.isEmpty)
    }
    
}

struct Fonts {
    
    private static let family = "AvenirNext"
    
    static let bold = "\(family)-Bold"
    static let demiBold = "\(family)-DemiBold"
    static let medium = "\(family)-Medium"
    static let regular = "\(family)-Regular"
    
}

/// UIColor relates constants.
struct Colors {
    
    static let red = UIColor(r: 185, g: 74, b: 72)
    static let lightRed = UIColor(r: 252, g: 98, b: 93)
    
    static let green = UIColor(r: 0, g: 197, b: 127)
    static let lightGreen = UIColor(r: 98, g: 202, b: 87)
    
    static let darkBlue = UIColor(r: 10, g: 64, b: 122)
    static let lightBlue = UIColor(r: 15, g: 98, b: 189)
    
    static let yellow = UIColor(r: 244, g: 192, b: 1)
    static let white = UIColor(r: 244, g: 247, b: 250)
    
    static let darkGray = UIColor(r: 26, g: 54, b: 80)
    static let gray = UIColor(r: 109, g: 115, b: 128)
    static let lightGray = UIColor(r: 219, g: 225, b: 232)
    
}

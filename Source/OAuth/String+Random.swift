//
//  String+Random.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

internal extension String {
    
    /// Creates a random alphanumeric String of given length.
    ///
    /// - Parameter length: The length of the random String to create.
    /// - Returns: Random alphanumeric String of given length.
    ///
    static func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.count)
        
        var resultString = ""
        
        for _ in 0 ..< length {
            let randomNumber = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNumber)
            let randomCharacter = allowedChars[randomIndex]
            
            resultString.append(randomCharacter)
        }
        
        return resultString
    }
    
}

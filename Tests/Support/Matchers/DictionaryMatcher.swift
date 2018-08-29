//
//  DictionaryMatcher.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Quick
import Nimble

func equalDictionary(_ expected: [String: Any?]) -> Predicate<[String: Any?]> {
    return Predicate.define { actualExpression in
        let msg = ExpectationMessage.expectedActualValueTo("be equal \(expected)")
        let optActual = try actualExpression.evaluate()
        guard let actual = optActual else {
            return PredicateResult(status: .fail, message: .fail("expected [String: Any], got <nil>"))
        }
        return PredicateResult(bool: actual == expected, message: msg)
    }
}

extension Dictionary where Key == String, Value == Any? {
    
    static func == (lhs: Dictionary, rhs: Dictionary) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        for (key, value) in lhs {
            switch value {
            case let value as String:
                guard rhs[key] as? String == value else {
                    return false
                }
            case let value as Int:
                guard rhs[key] as? Int == value else {
                    return false
                }
            case let value as Bool:
                guard rhs[key] as? Bool == value else {
                    return false
                }
            default: return false
            }
        }
        return true
    }
    
}

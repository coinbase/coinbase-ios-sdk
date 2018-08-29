//
//  SpecHelpers.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Quick
import Nimble
import CoinbaseSDK

/// The value will be cached across multiple calls in the same example but not across examples.
/// - Parameters:
///     - builder: Closure to build result variable
///
/// Note: `specVar` is lazy-evaluated: it is not evaluated until the first time result closure is invoked.
func specVar<T>(_ builder: @escaping () -> T) -> () -> T {
    var value: T?
    afterEach { value = nil }
    return {
        let builtValue = value ?? builder()
        value = builtValue
        return builtValue
    }
}

/// chain expectations for url
typealias URLRequestExpectation = (URLRequest) -> Void
func && (lhs: @escaping URLRequestExpectation, rhs: @escaping URLRequestExpectation) -> URLRequestExpectation {
    return { req in
        lhs(req)
        rhs(req)
    }
}

typealias ResultExpectation<T> = (Result<T>) -> Void
func &&<T> (lhs: @escaping ResultExpectation<T>, rhs: @escaping ResultExpectation<T>) -> ResultExpectation<T> {
    return { req in
        lhs(req)
        rhs(req)
    }
}

extension ToSucceedResult {
    static var wrongEnumCase: ToSucceedResult {
        return .failed(reason: "wrong enum case")
    }
    static var wrongEnumParameters: ToSucceedResult {
        return .failed(reason: "wrong enum parameters")
    }
}

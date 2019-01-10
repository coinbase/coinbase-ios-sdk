//
//  ResultMatchers.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Quick
import Nimble
import CoinbaseSDK

func beSuccessful<T>() -> Predicate<Result<T>> {
    return Predicate.define { actualExpression in
        let msg = ExpectationMessage.expectedActualValueTo("be successful")
        let optActual = try actualExpression.evaluate()
        guard let actual = optActual else {
            return PredicateResult(status: .fail, message: .fail("expected a result, got <nil>"))
        }
        return PredicateResult(bool: actual.isSuccess, message: msg)
    }
}

func beFailed<T>() -> Predicate<Result<T>> {
    return Predicate.define { actualExpression in
        let msg = ExpectationMessage.expectedActualValueTo("be failed")
        let optActual = try actualExpression.evaluate()
        guard let actual = optActual else {
            return PredicateResult(status: .fail, message: .fail("expected a result, got <nil>"))
        }
        return PredicateResult(bool: actual.isFailure, message: msg)
    }
}

func beFailed<T, U>(with: U.Type) -> Predicate<Result<T>> {
    return Predicate.define { actualExpression in
        let msg = ExpectationMessage.expectedActualValueTo("be failed with \(U.self)")
        let optActual = try actualExpression.evaluate()
        guard let actual = optActual else {
            return PredicateResult(status: .fail, message: .fail("expected a result, got <nil>"))
        }
        return PredicateResult(bool: actual.isFailure && type(of: actual.error!) == U.self, message: msg)
    }
}

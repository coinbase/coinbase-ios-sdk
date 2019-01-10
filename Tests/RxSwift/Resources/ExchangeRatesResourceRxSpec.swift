//
//  ExchangeRatesResourceRxSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class ExchangeRatesResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("ExchangeRatesResource") {
            let mockedSessionManager = specVar { MockedSessionManager() }
            let exchangeRatesResource = specVar { Coinbase(sessionManager: mockedSessionManager()).exchangeRatesResource }
            describe("rx_get(for") {
                it("make corrent request") {
                    let currencyCode = "currencyCode"
                    testSubscribe(exchangeRatesResource().rx_get(for: currencyCode))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? ExchangeRatesAPI
                        guard case .some(.get(currency: currencyCode)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

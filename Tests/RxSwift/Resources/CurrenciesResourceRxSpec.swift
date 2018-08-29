//
//  CurrenciesResourceRxSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class CurrenciesResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("CurrenciesResource") {
            let mockedSessionManager = specVar { MockedSessionManager() }
            let currenciesResource = specVar { Coinbase(sessionManager: mockedSessionManager()).currenciesResource }
            describe("rx_get") {
                it("make corrent request") {
                    testSubscribe(currenciesResource().rx_get())
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? CurrenciesAPI
                        guard case .some(.get) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

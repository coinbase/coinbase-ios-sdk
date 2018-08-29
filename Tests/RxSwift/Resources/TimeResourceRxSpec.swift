//
//  TimeResourceRxSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class TimeResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("TimeResource") {
            let mockedSessionManager = specVar { MockedSessionManager() }
            let timeResource = specVar { Coinbase(sessionManager: mockedSessionManager()).timeResource }
            describe("rx_get") {
                it("make corrent request") {
                    testSubscribe(timeResource().rx_get())
                        let expectedAPI = mockedSessionManager().lastRequest as? TimeAPI
                    expect({
                        guard case .some(.get) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

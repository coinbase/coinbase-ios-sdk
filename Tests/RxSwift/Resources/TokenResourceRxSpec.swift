//
//  TokenResourceRxSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class TokenResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("TokenResource") {
            let mockedSessionManager = specVar { MockedSessionManager() }
            let tokenResource = specVar { Coinbase(sessionManager: mockedSessionManager()).tokenResource }
            describe("rx_get") {
                it("make corrent request") {
                    let code = "code"
                    let clientID = StubConstants.clientID
                    let clientSecret = StubConstants.clientSecret
                    let redirectURI = "redirectURI"
                    testSubscribe(tokenResource().rx_get(code: code,
                                                         clientID: clientID,
                                                         clientSecret: clientSecret,
                                                         redirectURI: redirectURI))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TokensAPI
                        guard case .some(.get(code: code,
                                              clientID: clientID,
                                              clientSecret: clientSecret,
                                              redirectURI: redirectURI)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_refresh") {
                it("make corrent request") {
                    let refreshToken = "refreshToken"
                    let clientID = StubConstants.clientID
                    let clientSecret = StubConstants.clientSecret
                    testSubscribe(tokenResource().rx_refresh(clientID: clientID,
                                                             clientSecret: clientSecret,
                                                             refreshToken: refreshToken))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TokensAPI
                        guard case .some(.refresh(clientID: clientID,
                                                  clientSecret: clientSecret,
                                                  refreshToken: refreshToken)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_revoke") {
                it("make corrent request") {
                    testSubscribe(tokenResource().rx_revoke(accessToken: StubConstants.accessToken))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TokensAPI
                        guard case .some(.revoke(accessToken: StubConstants.accessToken)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

//
//  UserResourceRxSpec.swift
//  CoinbaseRx
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class UserResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("UserResource") {
            let accessToken = StubConstants.accessToken
            let mockedSessionManager = specVar { MockedSessionManager() }
            let userResource = specVar { Coinbase(accessToken: accessToken, sessionManager: mockedSessionManager()).userResource }
            describe("rx_get(by:)") {
                it("make corrent request") {
                    let userID = "user_id"
                    testSubscribe(userResource().rx_get(by: userID))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? UsersAPI
                        guard case .some(.user(userID)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("current") {
                it("make corrent request") {
                    testSubscribe(userResource().rx_current())
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? UsersAPI
                        guard case .some(.currentUser) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_authorizationInfo") {
                it("make corrent request") {
                    testSubscribe(userResource().rx_authorizationInfo())
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? UsersAPI
                        guard case .some(.authorizationInfo) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_updateCurrent") {
                it("make corrent request") {
                    let name = "name"
                    testSubscribe(userResource().rx_updateCurrent(name: name))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? UsersAPI
                        guard case .some(UsersAPI.update(name: name, timeZone: nil, nativeCurrency: nil)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

//
//  AccountsResourceRxSpec.swift
//  CoinbaseRxTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 
import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class AccountsResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("AccountResource") {
            let accountID = StubConstants.accountID
            let mockedSessionMenager = specVar { MockedSessionManager() }
            let accountResource = specVar { Coinbase(sessionManager: mockedSessionMenager()).accountResource }
            describe("rx_list") {
                it("make corrent request") {
                    let limit = 2
                    testSubscribe(accountResource().rx_list(page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AccountsAPI
                        guard case .some(.list(let page)) = expectedAPI, page.limit == limit else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_account") {
                it("make corrent request") {
                    testSubscribe(accountResource().rx_account(id: accountID))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AccountsAPI
                        guard case .some(.account(id: accountID)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_setAccountPrimary") {
                it("make corrent request") {
                    testSubscribe(accountResource().rx_setAccountPrimary(id: accountID))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AccountsAPI
                        guard case .some(.setPrimary(id: accountID)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_updateAccount") {
                let newName = "newName"
                it("make corrent request") {
                    testSubscribe(accountResource().rx_updateAccount(id: accountID, name: newName))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AccountsAPI
                        guard case .some(.update(id: accountID, name: newName)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_deleteAccount") {
                it("make corrent request") {
                    testSubscribe(accountResource().rx_deleteAccount(id: accountID))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AccountsAPI
                        guard case .some(.delete(id: accountID)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

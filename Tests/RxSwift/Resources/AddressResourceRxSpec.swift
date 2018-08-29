//
//  AddressResourceRxSpec.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class AddressResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("AddressResource") {
            let accountID = StubConstants.accountID
            let addressID = StubConstants.addressID
            let mockedSessionMenager = specVar { MockedSessionManager() }
            let addressResource = specVar { Coinbase(sessionManager: mockedSessionMenager()).addressResource }
            describe("rx_list") {
                it("make corrent request") {
                    let limit = 2
                    testSubscribe(addressResource().rx_list(accountID: accountID, page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AddressesAPI
                        guard case .some(.list(accountID, let page)) = expectedAPI, page.limit == limit else {
                            return .wrongEnumCase
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_address") {
                it("make corrent request") {
                    testSubscribe(addressResource().rx_address(accountID: accountID, addressID: addressID))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AddressesAPI
                        guard case .some(.address(accountID, addressID)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_transactions") {
                it("make corrent request") {
                    let limit = 2
                    let expandOptions: [TransactionExpandOption] = [.all]
                    testSubscribe(addressResource().rx_transactions(accountID: accountID, addressID: addressID, expandOptions: expandOptions, page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AddressesAPI
                        guard case .some(.transactions(accountID, addressID, let expand, let page)) = expectedAPI,
                            page.limit == limit else {
                                return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_create") {
                let name = "name"
                it("make corrent request") {
                    testSubscribe(addressResource().rx_create(accountID: accountID, name: name))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? AddressesAPI
                        guard case .some(.create(accountID, name)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

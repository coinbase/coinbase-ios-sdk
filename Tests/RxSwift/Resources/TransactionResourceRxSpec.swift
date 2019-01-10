//
//  TransactionResourceRxSpec.swift
//  CoinbaseRx
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class TransactionResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("UserResource") {
            let accessToken = StubConstants.accessToken
            let mockedSessionManager = specVar { MockedSessionManager() }
            let transactionResource = specVar { Coinbase(accessToken: accessToken,
                                                         sessionManager: mockedSessionManager()).transactionResource }
            let accountID = StubConstants.accountID
            let transactionID = StubConstants.transactionID
            let expandOptions: [TransactionExpandOption] = [.all]
            describe("rx_list(accountID:)") {
                it("make corrent request") {
                    let limit = 25
                    testSubscribe(transactionResource().rx_list(accountID: accountID,
                                                                expandOptions: expandOptions,
                                                                page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.list(accountID, let expand, let page)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard page.limit == limit, expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_transaction(accountID:transactionID:)") {
                it("make corrent request") {
                    testSubscribe(transactionResource().rx_transaction(accountID: accountID,
                                                                       transactionID: transactionID,
                                                                       expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.transaction(accountID, transactionID, let expand)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_send(accountID:twoFactorAuthToken:parameters:)") {
                it("make corrent request") {
                    let twoFactorAuthToken = "two_factor_auth_token"
                    let parameters = SendTransactionParameters(to: "to", amount: "0.00001", currency: "BTC", skipNotifications: true)
                    testSubscribe(transactionResource().rx_send(accountID: accountID,
                                                                twoFactorAuthToken: twoFactorAuthToken,
                                                                expandOptions: expandOptions,
                                                                parameters: parameters))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.send(accountID,
                                               twoFactorAuthToken: twoFactorAuthToken,
                                               let expand, let sentParameters)) = expectedAPI else { return .wrongEnumCase }
                        guard expand == expandOptions && sentParameters.toDictionary == parameters.toDictionary else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_request(accountID:parameters:)") {
                it("make corrent request") {
                    let parameters = RequestTransactionParameters(to: "to",
                                                                  amount: "0.00001",
                                                                  currency: "BTC")
                    testSubscribe(transactionResource().rx_request(accountID: accountID,
                                                                   expandOptions: expandOptions,
                                                                   parameters: parameters))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.request(accountID, let expand, let sentParameters)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions && sentParameters.toDictionary == parameters.toDictionary else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_completeRequest(accountID:transactionID:)") {
                it("make corrent request") {
                    testSubscribe(transactionResource().rx_completeRequest(accountID: accountID,
                                                                           transactionID: transactionID,
                                                                           expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.completeRequest(accountID, transactionID: transactionID, let expand)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_resendRequest(accountID:transactionID:)") {
                it("make corrent request") {
                    testSubscribe(transactionResource().rx_resendRequest(accountID: accountID,
                                                                         transactionID: transactionID,
                                                                         expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.resendRequest(accountID, transactionID: transactionID, let expand)) = expectedAPI else { return .wrongEnumCase }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_cancelRequest(accountID:transactionID:)") {
                it("make corrent request") {
                    testSubscribe(transactionResource().rx_cancelRequest(accountID: accountID, transactionID: transactionID))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TransactionsAPI
                        guard case .some(.cancelRequest(accountID, transactionID: transactionID)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

//
//  TradeResourceRxSpecProtocol.swift
//  CoinbaseRxTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

protocol TradeResourceRxSpecProtocol {
    func tradeSpec<T>(type: TradeResourceType, parameters: T.Parameters, resource: @escaping () -> T,
                      mockedSessionManager: @escaping () -> MockedSessionManager) where T: TradeResourceProtocol
}

extension TradeResourceRxSpecProtocol where Self: QuickSpec {
    
    func tradeSpec<T>(type: TradeResourceType, parameters: T.Parameters, resource: @escaping () -> T,
                      mockedSessionManager: @escaping () -> MockedSessionManager) where T: TradeResourceProtocol {
        
        let accountID = StubConstants.accountID
        let tradeID = StubConstants.tradeID
        let expandOptions = [TradeExpandOption.all]
        
        describe("\(T.self)") {
            describe("rx_list") {
                it("make corrent request") {
                    let limit = 2
                    testSubscribe(resource().rx_list(accountID: accountID, expandOptions: expandOptions, page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TradesAPI
                        guard case .some(.list(type, accountID, let expand, let page)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard page.limit == limit, expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_show") {
                it("make corrent request") {
                    testSubscribe(resource().rx_show(accountID: accountID, tradeID: tradeID, expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TradesAPI
                        guard case .some(.show(type, accountID, tradeID, let expand)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_placeOrder") {
                it("make corrent request") {
                    testSubscribe(resource().rx_placeOrder(accountID: accountID, expandOptions: expandOptions, parameters: parameters))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TradesAPI
                        guard case .some(.placeOrder(type, accountID, let expand, let sentParameters)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions, sentParameters.toDictionary == parameters.toDictionary else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_commit") {
                it("make corrent request") {
                    testSubscribe(resource().rx_commit(accountID: accountID, tradeID: tradeID, expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? TradesAPI
                        guard case .some(.commit(type, accountID, tradeID, let expand)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

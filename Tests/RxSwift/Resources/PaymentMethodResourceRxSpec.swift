//
//  PaymentMethodResourceRxSpec.swift
//  CoinbaseRxTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class PaymentMethodResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("PaymentMethodResource") {
            let paymentMethodID = StubConstants.paymentMethodID
            let mockedSessionMenager = specVar { MockedSessionManager() }
            let paymentMethodResource = specVar { Coinbase(sessionManager: mockedSessionMenager()).paymentMethodResource }
            let expandOptions: [PaymentMethodExpandOption] = [.all]
            
            describe("rx_list") {
                it("make corrent request") {
                    let limit = 25
                    testSubscribe(paymentMethodResource().rx_list(expandOptions: expandOptions, page: PaginationParameters(limit: limit)))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? PaymentMethodsAPI
                        guard case .some(.list(let expand, let page)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard page.limit == limit, expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_paymentMethod") {
                it("make corrent request") {
                    testSubscribe(paymentMethodResource().rx_paymentMethod(id: paymentMethodID, expandOptions: expandOptions))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? PaymentMethodsAPI
                        guard case .some(.paymentMethod(paymentMethodID, let expand)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        guard expand == expandOptions else {
                            return .wrongEnumParameters
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_deletePaymentMethod") {
                it("make corrent request") {
                    testSubscribe(paymentMethodResource().rx_deletePaymentMethod(id: paymentMethodID))
                    expect({
                        let expectedAPI = mockedSessionMenager().lastRequest as? PaymentMethodsAPI
                        guard case .some(.deletePaymentMethod(paymentMethodID)) = expectedAPI else {
                            return .wrongEnumCase
                        }
                        return .succeeded
                    }).to(succeed())
                }
            }
        }
    }
    
}

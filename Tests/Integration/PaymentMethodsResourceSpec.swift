//
//  PaymentMethodResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class PaymentMethodResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("PaymentMethodResource") {
            let paymentMethodID = StubConstants.paymentMethodID
            let paymentMethodResource = specVar { Coinbase(accessToken: StubConstants.accessToken).paymentMethodResource }
            describe("list") {
                let lastID = "last_id"
                let limit = 25
                let page = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                itBehavesLikeResource(with: "payment_methods.json",
                                      requestedBy: { completion in paymentMethodResource().list(expandOptions: [.fiatAccount], page: page, completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                                        url(withPath: "/payment-methods", query: ["limit": String(limit),
                                                                                  "order": "asc",
                                                                                  "ending_before": lastID,
                                                                                  "expand[]": "fiat_account"]),
                                      expectationsForResult: validList(result:))
            }
            describe("paymentMethod") {
                itBehavesLikeResource(with: "payment_method_by_id.json",
                                      requestedBy: { completion in paymentMethodResource().paymentMethod(id: paymentMethodID, expandOptions: [.all], completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                                        url(withPath: "/payment-methods/\(paymentMethodID)", query: ["expand[]": "all"]),
                                      expectationsForResult: valid(result:))
            }
            describe("deletePaymentMethod") {
                itBehavesLikeResource(with: nil,
                                      requestedBy: { completion in paymentMethodResource().deletePaymentMethod(id: paymentMethodID, completion: completion) },
                                      expectationsForRequest: request(ofMethod: .delete) && hasAuthorization() && url(withPath: "/payment-methods/\(paymentMethodID)"),
                                      expectationsForResult: successfulEmptyResult())
            }
        }
    }
    
    func validList(result: Result<ResponseModel<[PaymentMethod]>>) {
        expect(result).to(beSuccessful())
        expect(result.value?.data).notTo(beNil())
        
        let firstPaymentMethod = result.value?.data.first
        expect(firstPaymentMethod?.primarySell).to(beTrue())
        expect(firstPaymentMethod?.limits?.buy?.first?.total?.amount).notTo(beNil())
        expect(firstPaymentMethod?.limits?.sell?.first?.total?.amount).notTo(beNil())
        expect(firstPaymentMethod?.fiatAccount?.currency?.code).notTo(beNil())
        expect(firstPaymentMethod?.fiatAccount?.balance?.amount).notTo(beNil())
        
        let lastPaymentMethod = result.value?.data.last
        expect(lastPaymentMethod?.limits?.buy?.first?.total?.amount).notTo(beNil())
        expect(lastPaymentMethod?.limits?.buy?.first?.nextRequirement?.volume?.amount).notTo(beNil())
        expect(lastPaymentMethod?.limits?.sell?.first?.total?.amount).notTo(beNil())
        expect(lastPaymentMethod?.limits?.deposit?.first?.total?.amount).notTo(beNil())
        
    }
    
    func valid(result: Result<PaymentMethod>) {
        expect(result).to(beSuccessful())
        expect(result.value?.limits).notTo(beNil())
        expect(result.value?.fiatAccount).notTo(beNil())
    }
    
}

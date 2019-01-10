//
//  DepositResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick

class DepositResourceSpec: QuickSpec, IntegrationSpecProtocol, TradeResourceSpecProtocol {
    
    override func spec() {        
        let path = "/accounts/\(StubConstants.accountID)/deposits"
        let resource = specVar { Coinbase(accessToken: StubConstants.accessToken).depositResource }
        
        let amount = "1"
        let currency = "BTC"
        let commit = false
        let parameters = DepositWithdrawalParameters(amount: amount, currency: currency, paymentMethod: StubConstants.paymentMethodID, commit: commit)
        
        let expectedBody = ["amount": amount,
                            "currency": currency,
                            "payment_method": StubConstants.paymentMethodID,
                            "commit": String(commit)]
        
        tradeSpec(path: path, resourceName: "deposit", resource, parameters: parameters, expectedBody: expectedBody)
    }
    
}

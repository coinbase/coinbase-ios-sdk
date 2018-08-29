//
//  WithdrawalResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick

class WithdrawalResourceSpec: QuickSpec, IntegrationSpecProtocol, TradeResourceSpecProtocol {
    
    override func spec() {        
        let path = "/accounts/\(StubConstants.accountID)/withdrawals"
        let resource = specVar { Coinbase(accessToken: StubConstants.accessToken).withdrawalResource }
        
        let amount = "1"
        let currency = "BTC"
        let commit = false
        let parameters = DepositWithdrawalParameters(amount: amount, currency: currency, paymentMethod: StubConstants.paymentMethodID, commit: commit)
        
        let expectedBody = ["amount": amount,
                            "currency": currency,
                            "payment_method": StubConstants.paymentMethodID,
                            "commit": String(commit)]
        
        tradeSpec(path: path, resourceName: "withdrawal", resource, parameters: parameters, expectedBody: expectedBody)
    }
    
}

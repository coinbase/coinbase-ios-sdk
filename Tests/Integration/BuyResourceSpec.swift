//
//  BuyResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick

class BuyResourceSpec: QuickSpec, IntegrationSpecProtocol, TradeResourceSpecProtocol {
    
    override func spec() {        
        let path = "/accounts/\(StubConstants.accountID)/buys"
        let resource = specVar { Coinbase(accessToken: StubConstants.accessToken).buyResource }
        
        let amount = "1"
        let total = "2"
        let currency = "BTC"
        let agreeBTCAmountVaries = true
        let commit = false
        let quote = true
        let parameters = BuySellParameters(amount: amount, total: total, currency: currency, paymentMethod: StubConstants.paymentMethodID,
                                           agreeBTCAmountVaries: agreeBTCAmountVaries, commit: commit, quote: quote)
        
        let expectedBody = ["amount": amount,
                            "total": total,
                            "currency": currency,
                            "payment_method": StubConstants.paymentMethodID,
                            "agree_btc_amount_varies": String(agreeBTCAmountVaries),
                            "commit": String(commit),
                            "quote": String(quote)]
        
        tradeSpec(path: path, resourceName: "buy", resource, parameters: parameters, expectedBody: expectedBody)
    }
    
}

//
//  SellResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick

class SellResourceSpec: QuickSpec, IntegrationSpecProtocol, TradeResourceSpecProtocol {
    
    override func spec() {        
        let path = "/accounts/\(StubConstants.accountID)/sells"
        let resource = specVar { Coinbase(accessToken: StubConstants.accessToken).sellResource }
        
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
        
        tradeSpec(path: path, resourceName: "sell", resource, parameters: parameters, expectedBody: expectedBody)
    }
    
}

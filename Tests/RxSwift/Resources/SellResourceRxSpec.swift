//
//  SellResourceRxSpec.swift
//  CoinbaseRxTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class SellResourceRxSpec: QuickSpec, TradeResourceRxSpecProtocol {
    
    override func spec() {
        let mockedSessionManager = specVar { MockedSessionManager() }
        
        let type = TradeResourceType.sells
        let resource = specVar { Coinbase(sessionManager: mockedSessionManager()).sellResource }
        let parameters = BuySellParameters(amount: "1", total: "2", currency: "BTC", paymentMethod: "payment_method_id",
                                           agreeBTCAmountVaries: true, commit: false, quote: true)
        
        tradeSpec(type: type, parameters: parameters, resource: resource, mockedSessionManager: mockedSessionManager)
    }
    
}

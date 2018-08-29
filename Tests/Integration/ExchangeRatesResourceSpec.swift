//
//  ExchangeRatesResourceSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class ExchangeRatesResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("ExchangeRatesResource") {
            let exchangeRatesResource = specVar { Coinbase().exchangeRatesResource }
            let currency = "BTC"
            describe("get(for)") {
                itBehavesLikeResource(with: "exchange_rates.json",
                                      requestedBy: { comp in exchangeRatesResource().get(for: currency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/exchange-rates", query: ["currency": "BTC"]),
                                      expectationsForResult: valid(result:))
            }
        }
    }
    
    func valid(result: Result<ExchangeRates>) {
        expect(result).to(beSuccessful())
        expect(result.value?.currency).notTo(beEmpty())
        expect(result.value?.rates).notTo(beEmpty())
    }
    
}

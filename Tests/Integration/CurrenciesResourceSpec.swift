//
//  CurrenciesSpec.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class CurrenciesResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("CurrenciesResource") {
            let currenciesResource = specVar { Coinbase().currenciesResource }
            describe("get") {
                itBehavesLikeResource(with: "currencies.json",
                                      requestedBy: { comp in currenciesResource().get(completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/currencies"),
                                      expectationsForResult: valid(result:))
            }
        }
    }
    
    func valid(result: Result<[CurrencyInfo]>) {
        let currencies = result.value
        expect(result).to(beSuccessful())
        expect(currencies).notTo(beEmpty())
        expect(currencies?.first?.id).notTo(beEmpty())
        expect(currencies?.first?.minSize).notTo(beEmpty())
        expect(currencies?.first?.name).notTo(beEmpty())
    }
    
}

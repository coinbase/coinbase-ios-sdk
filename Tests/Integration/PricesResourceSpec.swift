//
//  PricesResourceSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class PricesResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("PricesResource") {
            let pricesResource = specVar { Coinbase().pricesResource }
            let requestDate = specVar { () -> Date in
                let calendar = Calendar(identifier: .iso8601)
                let components = DateComponents(year: 2018, month: 2, day: 2)
                return calendar.date(from: components)!
            }
            let requestDateString = "2018-02-02"
            let fiatCurrency = "USD"
            let baseCurrency = "BTC"
            let currencyPair = "\(baseCurrency)-\(fiatCurrency)"
            
            describe("buyPrice") {
                itBehavesLikeResource(with: "buy_price.json",
                                      requestedBy: { comp in pricesResource().buyPrice(base: baseCurrency, fiat: fiatCurrency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(currencyPair)/buy"),
                                      expectationsForResult: valid(result:))
            }
            describe("sellPrice") {
                itBehavesLikeResource(with: "sell_price.json",
                                      requestedBy: { comp in pricesResource().sellPrice(base: baseCurrency, fiat: fiatCurrency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(currencyPair)/sell"),
                                      expectationsForResult: valid(result:))
            }
            describe("spotPrice") {
                itBehavesLikeResource(with: "spot_price_btc_usd.json",
                                      requestedBy: { comp in pricesResource().spotPrice(base: baseCurrency, fiat: fiatCurrency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(currencyPair)/spot"),
                                      expectationsForResult: valid(result:))
                context("with date parameter") {
                    context("as Date") {
                        itBehavesLikeResource(with: "spot_price_btc_usd.json",
                                              requestedBy: { comp in pricesResource().spotPrice(base: baseCurrency, fiat: fiatCurrency, at: requestDate(), completion: comp) },
                                              expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(currencyPair)/spot", query: ["date": "2018-02-02"]),
                                              expectationsForResult: valid(result:))
                    }
                    context("as String") {
                        itBehavesLikeResource(with: "spot_price_btc_usd.json",
                                              requestedBy: { comp in pricesResource().spotPrice(base: baseCurrency, fiat: fiatCurrency, at: requestDateString, completion: comp) },
                                              expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(currencyPair)/spot", query: ["date": "2018-02-02"]),
                                              expectationsForResult: valid(result:))
                    }
                }
            }
            describe("spotPrices") {
                itBehavesLikeResource(with: "spot_prices_usd.json",
                                      requestedBy: { comp in pricesResource().spotPrices(fiat: fiatCurrency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(fiatCurrency)/spot"),
                                      expectationsForResult: valid(result:))
                context("with date parameter") {
                    context("as Date") {
                        itBehavesLikeResource(with: "spot_prices_usd.json",
                                              requestedBy: { comp in pricesResource().spotPrices(fiat: fiatCurrency, at: requestDate(), completion: comp) },
                                              expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(fiatCurrency)/spot", query: ["date": "2018-02-02"]),
                                              expectationsForResult: valid(result:))
                    }
                    context("as String") {
                        itBehavesLikeResource(with: "spot_prices_usd.json",
                                              requestedBy: { comp in pricesResource().spotPrices(fiat: fiatCurrency, at: requestDateString, completion: comp) },
                                              expectationsForRequest: request(ofMethod: .get) && url(withPath: "/prices/\(fiatCurrency)/spot", query: ["date": "2018-02-02"]),
                                              expectationsForResult: valid(result:))
                    }
                }
            }
        }
    }
    
    func valid(result: Result<Price>) {
        expect(result).to(beSuccessful())
        expect(result.value?.base).notTo(beEmpty())
        expect(result.value?.currency).notTo(beEmpty())
        expect(result.value?.amount).notTo(beEmpty())
    }
    
    func valid(result: Result<[Price]>) {
        expect(result).to(beSuccessful())
        expect(result.value).notTo(beEmpty())
        expect(result.value?.first?.base).notTo(beEmpty())
        expect(result.value?.first?.currency).notTo(beEmpty())
        expect(result.value?.first?.amount).notTo(beEmpty())
    }
    
}

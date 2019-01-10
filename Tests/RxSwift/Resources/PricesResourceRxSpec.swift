//
//  PricesResourceRxSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble

class PricesResourceRxSpec: QuickSpec {
    
    override func spec() {
        describe("PricesResource") {
            let baseCurrency = "baseCurrency"
            let fiatCurrency = "fiatCurrency"
            
            let dateString = "2018-01-01"
            let formater = DateFormatter()
            formater.dateFormat = "YYYY-MM-dd"
            let date = formater.date(from: dateString)!
            
            let mockedSessionManager = specVar { MockedSessionManager() }
            let pricesResource = specVar { Coinbase(sessionManager: mockedSessionManager()).pricesResource }
            
            describe("rx_buyPrice") {
                it("make corrent request") {
                    testSubscribe(pricesResource().rx_buyPrice(base: baseCurrency, fiat: fiatCurrency))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                        guard case .some(.buy(base: baseCurrency, fiat: fiatCurrency)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_sellPrice") {
                it("make corrent request") {
                    testSubscribe(pricesResource().rx_sellPrice(base: baseCurrency, fiat: fiatCurrency))
                    expect({
                        let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                        guard case .some(.sell(base: baseCurrency, fiat: fiatCurrency)) = expectedAPI else { return .wrongEnumCase }
                        return .succeeded
                    }).to(succeed())
                }
            }
            describe("rx_spotPrice") {
                context("when date is String ") {
                    it("make corrent request") {
                        testSubscribe(pricesResource().rx_spotPrice(base: baseCurrency, fiat: fiatCurrency, at: dateString))
                        expect({
                            let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                            guard case .some(.spot(base: baseCurrency, fiat: fiatCurrency, at: dateString)) = expectedAPI else { return .wrongEnumCase }
                            return .succeeded
                        }).to(succeed())
                    }
                }
                context("when date is Date ") {
                    it("make corrent request") {
                        testSubscribe(pricesResource().rx_spotPrice(base: baseCurrency, fiat: fiatCurrency, at: date))
                        expect({
                            let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                            guard case .some(.spot(base: baseCurrency, fiat: fiatCurrency, at: dateString)) = expectedAPI else { return .wrongEnumCase }
                            return .succeeded
                        }).to(succeed())
                    }
                }
                
            }
            describe("rx_spotPrices") {
                context("when date is String ") {
                    it("make corrent request") {
                        testSubscribe(pricesResource().rx_spotPrices(fiat: fiatCurrency, at: dateString))
                        expect({
                            let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                            guard case .some(.spotFor(fiat: fiatCurrency, at: dateString)) = expectedAPI else { return .wrongEnumCase }
                            return .succeeded
                        }).to(succeed())
                    }
                }
                context("when date is Date ") {
                    it("make corrent request") {
                        testSubscribe(pricesResource().rx_spotPrices(fiat: fiatCurrency, at: date))
                        expect({
                            let expectedAPI = mockedSessionManager().lastRequest as? PricesAPI
                            guard case .some(.spotFor(fiat: fiatCurrency, at: dateString)) = expectedAPI else { return .wrongEnumCase }
                            return .succeeded
                        }).to(succeed())
                    }
                }
            }
        }
    }
    
}

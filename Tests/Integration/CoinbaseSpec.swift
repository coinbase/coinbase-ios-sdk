//
//  CoinbaseSDKSpec.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class CoinbaseSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("Coinbase") {
            describe("init") {
                context("when baseURL provided explicitly") {
                    let otherBaseURL = "https://other.host.com"
                    let coinbase = specVar { Coinbase(baseURL: otherBaseURL) }
                    context("for basic resource") {
                        useStub(condition: anyRequest(), with: "currencies.json")
                        it("provide baseURL to resources") {
                            checkRequest { request in
                                expect(request.url?.absoluteString).to(beginWith(otherBaseURL))
                            }
                            make(coinbase().currenciesResource.get(completion:))
                        }
                    }
                    context("for token resource") {
                        useStub(condition: anyRequest(), with: "token.json")
                        it("provide baseURL from constant") {
                            checkRequest { request in
                                expect(request.url?.absoluteString).to(beginWith(NetworkConstants.baseURL))
                            }
                            make({ comp in coinbase().tokenResource.get(code: "", clientID: "", clientSecret: "", redirectURI: "", completion: comp)})
                        }
                    }
                }
                context("when baseURL provided implicitly") {
                    let coinbase = specVar { Coinbase() }
                    context("for basic resource") {
                        useStub(condition: anyRequest(), with: "currencies.json")
                        it("provide baseURL from constant") {
                            checkRequest { request in
                                expect(request.url?.absoluteString).to(beginWith(NetworkConstants.baseURLv2))
                            }
                            make(coinbase().currenciesResource.get(completion:))
                        }
                    }
                }
            }
            
            describe("setRefreshStrategy") {
                let coinbase = specVar { Coinbase() }
                it("changes interseptors") {
                    coinbase().setRefreshStrategy(.refresh(clientID: StubConstants.clientID,
                                                           clientSecret: StubConstants.clientSecret,
                                                           refreshToken: "refresh",
                                                           onUserTokenUpdate: nil))
                    expect(coinbase().sessionManager.interceptors).notTo(beEmpty())
                    coinbase().setRefreshStrategy(.none)
                    expect(coinbase().sessionManager.interceptors).to(beEmpty())
                }
            }
        }
    }
    
}

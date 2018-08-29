//
//  SessionManagerSpec.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class SessionManagerSpec: QuickSpec {
    override func spec() {
        describe("SessionManager") {
            describe("init") {
                context("with custom headers") {
                    context("when custom header override default") {
                        it("use default header value") {
                            let sessionManager = SessionManager(sessionHeaders: ["Accept": "newValue"])
                            let value = sessionManager.session.configuration.httpAdditionalHeaders?["Accept"] as? String
                            expect(value).to(equal("application/json"))
                        }
                    }
                    context("when custom header not override default") {
                        it("adds custom header") {
                            let sessionManager = SessionManager(sessionHeaders: ["CustomHeader": "newValue"])
                            let value = sessionManager.session.configuration.httpAdditionalHeaders?["CustomHeader"] as? String
                            expect(value).to(equal("newValue"))
                        }
                    }
                }
            }
        }
    }
}

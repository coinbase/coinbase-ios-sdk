//
//  UsersSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class UsersSpec: QuickSpec {
    
    override func spec() {
        context("user(id: String)") {
            let resource = specVar { UsersAPI.user(id: "1") }
            describe("path") {
                it("returns path to endpoint") {
                    expect(resource().path).to(equal("/users/1"))
                }
            }
            describe("method") {
                it("returns right method") {
                    expect(resource().method).to(equal(HTTPMethod.get))
                }
            }
            describe("headers") {
                it("return request headers") {
                    expect(resource().headers).to(beEmpty())
                }
            }
        }
        context("currentUser") {
            let resource = specVar { UsersAPI.currentUser }
            describe("path") {
                it("returns path to endpoint") {
                    expect(resource().path).to(equal("/user"))
                }
            }
            describe("method") {
                it("returns right method") {
                    expect(resource().method).to(equal(HTTPMethod.get))
                }
            }
            describe("headers") {
                it("return request headers") {
                    expect(resource().headers).to(beEmpty())
                }
            }
        }
    }
    
}

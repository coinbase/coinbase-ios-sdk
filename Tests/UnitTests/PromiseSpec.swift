//
//  PromiseSpec.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class PromiseSpec: QuickSpec {
    override func spec() {
        describe("Promise<DefaultResponse>.convert") {
            context("when response has no data") {
                let defaultResponse = DefaultResponse(request: nil, response: nil, data: nil, error: nil)
                let promise = Promise(value: defaultResponse)
                it("creates Promise with Response and failure result") {
                    var promisedResponse: Response<Data>!
                    waitUntil { done in
                        promise.convert(to: Data.self).then { response in
                            promisedResponse = response
                            done()
                        }
                    }
                    expect(promisedResponse.result).to(beFailed(with: ResponseSerializationError.self))
                }
            }
        }
    }
}

//
//  IntegrationSpecHelpers.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs
private let defaultHeaders = ["content-type": "application/json; charset=utf-8"]

func useStub(condition: @escaping OHHTTPStubsTestBlock, with datafile: String?, status: Int32 = 200) {
    beforeEach {
        stub(condition: condition, response: { _ in
            if let datafile = datafile {
                return fixture(filePath: OHPathForFile(datafile, CoinbaseSpec.self)!,
                        status: status,
                        headers: defaultHeaders)
            } else {
                return OHHTTPStubsResponse(data: Data(), statusCode: status, headers: defaultHeaders)
            }
        })
    }
}

func itBehavesLikeResource<T>(with datafile: String?,
                              requestedBy request: @escaping (@escaping (Result<T>) -> Void) -> Void ,
                              expectationsForRequest: (@escaping (URLRequest) -> Void),
                              expectationsForResult: (@escaping (Result<T>) -> Void)) {
    useStub(condition: anyRequest(), with: datafile)
    it("create valid request") {
        checkRequest(expectationsForRequest)
        make(request)
    }
    it("get result") {
        waitUntil { done in
            request { result in
                expectationsForResult(result)
                done()
            }
        }
    }
}

func checkRequest(_ validator: @escaping URLRequestExpectation) {
    OHHTTPStubs.onStubActivation { (request, _, _) in
        validator(request)
    }
}

func make<T>(_ request:@escaping (@escaping (Result<T>) -> Void) -> Void) {
    waitUntil { done in
        request { _ in
            done()
        }
    }
}

/// matcher for any requests
func anyRequest() -> OHHTTPStubsTestBlock {
    return { _ in true }
}

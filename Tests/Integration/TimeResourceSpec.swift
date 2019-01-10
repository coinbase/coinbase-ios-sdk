//
//  TimeResourceSpec.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class TimeResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("TimeResource") {
            let timeResource = specVar { Coinbase().timeResource }
            describe("getTime") {
                itBehavesLikeResource(with: "time.json",
                                      requestedBy: { comp in timeResource().get(completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/time"),
                                      expectationsForResult: valid(result:))
            }
        }
    }
    
    func valid(result: Result<TimeInfo>) {
        expect(result).to(beSuccessful())
        expect(result.value?.iso).to(beAKindOf(Date.self))
        expect(result.value?.epoch).to(beAKindOf(Double.self))
        expect(result.value?.epoch).to(beGreaterThan(0))
        expect(result.value?.iso).to(beCloseTo(Date(timeIntervalSince1970: Double(result.value!.epoch))))
    }
    
}

//
//  SessionManagerSpec.swift
//  CoinbaseRxTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import CoinbaseSDK
@testable import RxCoinbaseSDK
import Quick
import Nimble
import RxSwift

class SessionManagerSpec: QuickSpec {
    override func spec() {
        describe("SessionManager") {
            describe("completion") {
                var result: Result<Data> = .success(Data())
                let single = specVar { () -> Single<Data> in
                    Single.create { single in
                        let completion = SessionManager.completion(with: single)
                        completion(result)
                        return Disposables.create()
                    }
                }
                context("with success result") {
                    beforeEach {
                        result = .success(Data())
                    }
                    it("create success single" ) {
                        var isSuccess = false
                        waitUntil { done in
                            _ = single().subscribe({ event in
                                switch event {
                                case .success: isSuccess = true
                                case .error: isSuccess = false
                                }
                                done()
                            })
                        }
                        expect(isSuccess).to(beTrue())
                    }
                }
                context("with failure result") {
                    beforeEach {
                        result = Result.failure(NSError())
                    }
                    it("create error single") {
                        var isSuccess = false
                        waitUntil { done in
                            _ = single().subscribe({ event in
                                switch event {
                                case .success: isSuccess = true
                                case .error: isSuccess = false
                                }
                                done()
                            })
                        }
                        expect(isSuccess).to(beFalse())
                    }
                }
            }
        }
    }
}

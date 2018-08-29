//
//  PaginationParametersSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class PaginationParametersSpec: QuickSpec {
    
    override func spec() {
        describe("PaginationParameters") {
            context("init(uri)") {
                var uri: String? = ""
                let pagination = specVar { Pagination(limit: 10, order: .desc, previousURI: uri, nextURI: uri) }
                let model = specVar { PaginationParameters.nextPage(from: pagination()) }
                context("with all options uri") {
                    beforeEach {
                        uri = "/v2/accounts/some_id/transactions?limit=10&starting_after=other_id&order=desc"
                    }
                    it("create model with all parameters") {
                        expect(model()).notTo(beNil())
                        expect(model()?.limit).notTo(beNil())
                        expect(model()?.order).notTo(beNil())
                        expect(model()?.cursor).notTo(beNil())
                    }
                }
                context("with nil uri") {
                    beforeEach {
                        uri = nil
                    }
                    it("returns nil") {
                        expect(model()).to(beNil())
                    }
                }
                context("with not parameter") {
                    beforeEach {
                        uri = "/v2/accounts/some_id/transactions"
                    }
                    it("create model") {
                        expect(model()).notTo(beNil())
                        expect(model()?.limit).to(beNil())
                        expect(model()?.order).to(beNil())
                        expect(model()?.cursor).to(beNil())
                    }
                }
                context("with order parameter") {
                    beforeEach {
                        uri = "/v2/accounts/some_id/transactions?order=desc"
                    }
                    context("desc") {
                        it("create model") {
                            expect(model()).notTo(beNil())
                            expect(model()?.order).to(equal(ListOrder.desc))
                        }
                    }
                    context("asc") {
                        beforeEach {
                            uri = "/v2/accounts/some_id/transactions?order=asc"
                        }
                        it("create model") {
                            expect(model()).notTo(beNil())
                            expect(model()?.order).to(equal(ListOrder.asc))
                        }
                    }
                    context("unparsable") {
                        beforeEach {
                            uri = "/v2/accounts/some_id/transactions?order=other"
                        }
                        it("create model") {
                            expect(model()).notTo(beNil())
                            expect(model()?.order).to(beNil())
                        }
                    }
                }
                context("with limit parameter") {
                    context("as number") {
                        beforeEach {
                            uri = "/v2/accounts/some_id/transactions?limit=10"
                        }
                        it("create model") {
                            expect(model()).notTo(beNil())
                            expect(model()?.limit).to(equal(10))
                        }
                    }
                    context("unparsable") {
                        beforeEach {
                            uri = "/v2/accounts/some_id/transactions?limit=sfds"
                        }
                        it("create model") {
                            expect(model()).notTo(beNil())
                            expect(model()?.limit).to(beNil())
                        }
                    }
                }
                context("with ending_before parameter") {
                    beforeEach {
                        uri = "/v2/accounts/some_id/transactions?ending_before=some_id"
                    }
                    it("create model") {
                        expect(model()).notTo(beNil())
                        expect({
                            guard case .some(.endingBefore(let id)) = model()?.cursor else {
                                return .failed(reason: "wrong enum case")
                            }
                            expect(id).to(equal("some_id"))
                            return .succeeded
                        }).to(succeed())
                    }
                }
                context("with starting_after parameter") {
                    beforeEach {
                        uri = "/v2/accounts/some_id/transactions?starting_after=some_id"
                    }
                    it("create model") {
                        expect(model()).notTo(beNil())
                        expect({
                            guard case .some(.startingAfter(let id)) = model()?.cursor else {
                                return .failed(reason: "wrong enum case")
                            }
                            expect(id).to(equal("some_id"))
                            return .succeeded
                        }).to(succeed())
                    }
                }
            }
            context("dictinary") {
                context("empty model") {
                    it("retrun empty dictinary") {
                        let model = PaginationParameters()
                        expect(model.parameters).to(beEmpty())
                    }
                }
                context("full model") {
                    it("retrun full dictinary") {
                        let model = PaginationParameters(limit: 10, order: .desc, cursor: .endingBefore(id: "some_id"))
                        expect(model.parameters).notTo(beEmpty())
                        expect(model.parameters["limit"]).notTo(beEmpty())
                        expect(model.parameters["order"]).notTo(beEmpty())
                        expect(model.parameters["ending_before"]).notTo(beEmpty())
                        expect(model.parameters["starting_after"]).to(beNil())
                    }
                }
                context("model with limit") {
                    it("retrun dictinary") {
                        let model = PaginationParameters(limit: 10)
                        expect(model.parameters["limit"]).to(equal("10"))
                    }
                }
                context("model with order") {
                    context("desc") {
                        it("retrun dictinary") {
                            let model = PaginationParameters(order: .desc)
                            expect(model.parameters["order"]).to(equal("desc"))
                        }
                    }
                    context("asc") {
                        it("retrun dictinary") {
                            let model = PaginationParameters(order: .asc)
                            expect(model.parameters["order"]).to(equal("asc"))
                        }
                    }
                }
                context("model with startingAfter") {
                    it("retrun dictinary") {
                        let model = PaginationParameters(cursor: .startingAfter(id: "id1"))
                        expect(model.parameters["starting_after"]).to(equal("id1"))
                    }
                }
                context("model with startingAfter") {
                    it("retrun dictinary") {
                        let model = PaginationParameters(cursor: .endingBefore(id: "id1"))
                        expect(model.parameters["ending_before"]).to(equal("id1"))
                    }
                }
            }
        }
    }
    
}

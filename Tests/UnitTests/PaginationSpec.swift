//
//  PaginationSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import Foundation

class PaginationSpec: QuickSpec {
    
    override func spec() {
        describe("Pagination") {
            let pagination = specVar {
                Pagination(limit: 10,
                           order: .desc,
                           previousURI: "/v2/accounts/some_id/transactions?limit=10&starting_after=some_id&order=desc",
                           nextURI: "v2/accounts/some_id/transactions?limit=10&starting_after=other_id&order=desc")
            }
            let nilPagination = specVar {
                Pagination(limit: 10, order: .desc)
            }
            describe("nextPage") {
                it("return PaginationParameters built from nextUri") {
                    let nextPage = PaginationParameters.nextPage(from: pagination())
                    expect(nextPage).to(beAKindOf(PaginationParameters.self))
                    expect({
                        guard case .some(.startingAfter(let id)) = nextPage?.cursor else {
                            return .failed(reason: "wrong enum case")
                        }
                        expect(id).to(equal("other_id"))
                        return .succeeded
                    }).to(succeed())
                }
                context("when no nextUri") {
                    it("return nil") {
                        let nextPage = PaginationParameters.nextPage(from: nilPagination())
                        expect(nextPage).to(beNil())
                    }
                }
            }
            describe("previousPage") {
                it("return PaginationParameters built from prevUri") {
                    let previousPage = PaginationParameters.previousPage(from: pagination())
                    expect(previousPage).to(beAKindOf(PaginationParameters.self))
                    expect({
                        guard case .some(.startingAfter(let id)) = previousPage?.cursor else {
                            return .failed(reason: "wrong enum case")
                        }
                        expect(id).to(equal("some_id"))
                        return .succeeded
                    }).to(succeed())
                }
                context("when no prevUri") {
                    it("return nil") {
                        let previousPage = PaginationParameters.previousPage(from: nilPagination())
                        expect(previousPage).to(beNil())
                    }
                }
            }
            describe("init from data") {
                let endingBeforeID = "ending_before_id"
                let startingAfterID = "starting_after_id"
                let limit = 25
                let order = ListOrder.desc
                let previousURI = "/v2/accounts/some_id/transactions?limit=10&starting_after=some_id&order=desc"
                let nextURI = "v2/accounts/some_id/transactions?limit=10&starting_after=other_id&order=desc"
                let paginationJSON = """
                {
                    "ending_before": "\(endingBeforeID)",
                    "starting_after": "\(startingAfterID)",
                    "limit": \(limit),
                    "order": "\(order.rawValue)",
                    "previous_uri": "\(previousURI)",
                    "next_uri": "\(nextURI)"
                }
                """
                let data = paginationJSON.data(using: .utf8)!
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let page = try? decoder.decode(Pagination.self, from: data)
                
                it("parses ending_before") {
                    expect(page?.endingBefore).to(equal(endingBeforeID))
                }
                it("parses starting_after") {
                    expect(page?.startingAfter).to(equal(startingAfterID))
                }
                it("parses limit") {
                    expect(page?.limit).to(equal(limit))
                }
                it("parses order") {
                    expect(page?.order).to(equal(order))
                }
                it("parses previous_uri") {
                    expect(page?.previousURI).to(equal(previousURI))
                }
                it("parses next_uri") {
                    expect(page?.nextURI).to(equal(nextURI))
                }
            }
        }
    }
    
}

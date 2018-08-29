//
//  TradeResourceSpecProtocol.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

protocol TradeResourceSpecProtocol {
    func tradeSpec<T>(path: String, resourceName: String, _ resource: @escaping () -> T, parameters: T.Parameters,
                      expectedBody: [String: String]) where T: TradeResourceProtocol
}

extension TradeResourceSpecProtocol where Self: IntegrationSpecProtocol {
    
    internal func tradeSpec<T>(path: String, resourceName: String, _ resource: @escaping () -> T, parameters: T.Parameters,
                               expectedBody: [String: String]) where T: TradeResourceProtocol {
        describe("\(T.self)") {
            let expandOptions = [TradeExpandOption.all]
            
            describe("list") {
                let limit = 25
                let lastID = "last_id"
                let page = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                
                let expectedQuery = ["limit": String(limit),
                                     "order": "asc",
                                     "ending_before": lastID,
                                     "expand[]": "all" ]
                itBehavesLikeResource(with: "\(resourceName)_list.json",
                    requestedBy: { completion in resource().list(accountID: StubConstants.accountID,
                                                                 expandOptions: expandOptions,
                                                                 page: page,
                                                                 completion: completion) },
                    expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                        url(withPath: path, query: expectedQuery),
                    expectationsForResult: validList(type: T.self))
            }
            describe("show") {
                itBehavesLikeResource(with: "\(resourceName).json",
                    requestedBy: { completion in resource().show(accountID: StubConstants.accountID,
                                                                 tradeID: StubConstants.tradeID,
                                                                 expandOptions: expandOptions,
                                                                 completion: completion) },
                    expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                        url(withPath: "\(path)/\(StubConstants.tradeID)", query: ["expand[]": "all" ]),
                    expectationsForResult: valid(type: T.self))
            }
            describe("placeOrder") {
                itBehavesLikeResource(with: "\(resourceName)_place_order.json",
                    requestedBy: { completion in resource().placeOrder(accountID: StubConstants.accountID,
                                                                       expandOptions: expandOptions,
                                                                       parameters: parameters,
                                                                       completion: completion) },
                    expectationsForRequest: request(ofMethod: .post) && hasAuthorization() &&
                        url(withPath: path, query: ["expand[]": "all" ]) && hasBody(parameters: expectedBody),
                    expectationsForResult: valid(type: T.self))
            }
            describe("commit") {
                itBehavesLikeResource(with: "\(resourceName)_commit.json",
                    requestedBy: { completion in resource().commit(accountID: StubConstants.accountID,
                                                                   tradeID: StubConstants.tradeID,
                                                                   expandOptions: expandOptions,
                                                                   completion: completion) },
                    expectationsForRequest: request(ofMethod: .post) && hasAuthorization() &&
                        url(withPath: "\(path)/\(StubConstants.tradeID)/commit", query: ["expand[]": "all" ]),
                    expectationsForResult: valid(type: T.self))
            }
            
        }
    }
    
    private func validList<T>(type: T.Type) -> ResultExpectation<ResponseModel<[T.Model]>> where T: TradeResourceProtocol {
        return { result in
            expect(result).to(beSuccessful())
            expect(result.value).notTo(beNil())
            expect(result.value?.data).notTo(beEmpty())
        }
    }
    
    private func valid<T>(type: T.Type) -> ResultExpectation<T.Model> where T: TradeResourceProtocol {
        return { result in
            expect(result).to(beSuccessful())
            expect(result.value).notTo(beNil())
        }
    }
    
}

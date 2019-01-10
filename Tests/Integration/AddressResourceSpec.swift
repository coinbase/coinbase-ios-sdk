//
//  AddressResourceSpec.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class AddressResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        describe("AddressResource") {
            let accountID = StubConstants.accountID
            let addressID = StubConstants.addressID
            let addressResource = specVar { Coinbase(accessToken: StubConstants.accessToken).addressResource }
            describe("list") {
                let lastID = "last_id"
                let limit = 25
                let page = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                itBehavesLikeResource(with: "addresses_list.json",
                                      requestedBy: { completion in addressResource().list(accountID: accountID,
                                                                                          page: page,
                                                                                          completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                                        url(withPath: "/accounts/\(accountID)/addresses", query: ["limit": String(limit),
                                                                                                  "order": "asc",
                                                                                                  "ending_before": lastID]),
                                      expectationsForResult: successfulList(ofType: Address.self))
            }
            describe("address") {
                itBehavesLikeResource(with: "address.json",
                                      requestedBy: { completion in addressResource().address(accountID: accountID,
                                                                                             addressID: addressID,
                                                                                             completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/accounts/\(accountID)/addresses/\(addressID)") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Address.self))
            }
            describe("transactions") {
                let expandOptions: [TransactionExpandOption] = [.all]
                let lastID = "last_id"
                let limit = 25
                let page = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                itBehavesLikeResource(with: "address_transactions.json",
                                      requestedBy: { completion in addressResource().transactions(accountID: accountID,
                                                                                                  addressID: addressID,
                                                                                                  expandOptions: expandOptions,
                                                                                                  page: page,
                                                                                                  completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                                        url(withPath: "/accounts/\(accountID)/addresses/\(addressID)/transactions",
                                            query: ["limit": String(limit),
                                                    "order": "asc",
                                                    "ending_before": lastID,
                                                    "expand[]": "all"]),
                                      expectationsForResult: successfulList(ofType: Transaction.self))
            }
            describe("create") {
                let name = "Transaction Name"
                itBehavesLikeResource(with: "address.json",
                                      requestedBy: { completion in addressResource().create(accountID: accountID,
                                                                                            name: name,
                                                                                            completion: completion) },
                                      expectationsForRequest: request(ofMethod: .post) && hasBody(parameters: ["name": name])
                                        && url(withPath: "/accounts/\(accountID)/addresses") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Address.self))
            }
        }
    }
    
}

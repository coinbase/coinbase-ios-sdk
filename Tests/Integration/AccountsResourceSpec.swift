//
//  AccountsResourceSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class AccountsResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        describe("AccountResource") {
            let accountID = StubConstants.accountID
            let accountResource = specVar { Coinbase(accessToken: StubConstants.accessToken).accountResource }
            describe("list") {
                let lastID = "user_id"
                let limit = 5
                let pageParams = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                itBehavesLikeResource(with: "accounts_list.json",
                                      requestedBy: { comp in accountResource().list(page: pageParams, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) &&
                                        url(withPath: "/accounts", query: ["limit": String(limit), "order": "asc", "ending_before": lastID]) &&
                                        hasAuthorization(),
                                      expectationsForResult: successfulList(ofType: Account.self))
            }
            describe("account(id:)") {
                itBehavesLikeResource(with: "account.json",
                                      requestedBy: { comp in accountResource().account(id: accountID, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/accounts/\(accountID)") && hasAuthorization(),
                                      expectationsForResult: valid(account:))
            }
            describe("setAccountPrimary(id:)") {
                itBehavesLikeResource(with: "account.json",
                                      requestedBy: { comp in accountResource().setAccountPrimary(id: accountID, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .post) && url(withPath: "/accounts/\(accountID)/primary") && hasAuthorization(),
                                      expectationsForResult: valid(account:))
            }
            describe("updateAccount(id:, name:)") {
                let newName = "name"
                let expectedBody = [
                    "name": newName
                ]
                itBehavesLikeResource(with: "account.json",
                                      requestedBy: { comp in accountResource().updateAccount(id: accountID, name: newName, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .put) && url(withPath: "/accounts/\(accountID)") && hasBody(parameters: expectedBody) && hasAuthorization(),
                                      expectationsForResult: valid(account:))
            }
            describe("deleteAccount(id:)") {
                itBehavesLikeResource(with: nil,
                                      requestedBy: { comp in accountResource().deleteAccount(id: accountID, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .delete) && url(withPath: "/accounts/\(accountID)") && hasAuthorization(),
                                      expectationsForResult: successfulEmptyResult())
            }
        }
    }
    
    func valid(account result: Result<Account>) {
        expect(result).to(beSuccessful())
        expect(result.value?.id).notTo(beNil())
        expect(result.value?.currency).to(beAKindOf(Currency.self))
        expect(result.value?.currency?.color).notTo(beNil())
        expect(result.value?.currency?.exponent).notTo(beNil())
        expect(result.value?.currency?.name).notTo(beNil())
        expect(result.value?.currency?.type).notTo(beNil())
    }
    
}

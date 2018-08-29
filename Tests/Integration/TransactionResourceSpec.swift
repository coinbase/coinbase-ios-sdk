//
//  TransactionResourceSpec.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class TransactionResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        describe("TransactionResource") {
            let accountID = StubConstants.accountID
            let transactionID = StubConstants.transactionID
            
            let transactionsPath = "/accounts/\(accountID)/transactions"
            let transactionPath = "\(transactionsPath)/\(transactionID)"
            
            let transactionResource = specVar { Coinbase(accessToken: StubConstants.accessToken).transactionResource }
            let expandOptions: [TransactionExpandOption] = [.all]
            describe("list") {
                let lastID = "last_id"
                let limit = 25
                let page = PaginationParameters(limit: limit, order: .asc, cursor: PaginationParameters.Cursor.endingBefore(id: lastID))
                itBehavesLikeResource(with: "list_transactions.json",
                                      requestedBy: { completion in transactionResource().list(accountID: accountID, expandOptions: expandOptions, page: page, completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && hasAuthorization() &&
                                        url(withPath: transactionsPath, query: ["limit": String(limit),
                                                                                "order": "asc",
                                                                                "ending_before": lastID,
                                                                                "expand[]": "all"
                                            ]),
                                      expectationsForResult: successfulList(ofType: Transaction.self))
            }
            describe("transaction") {
                itBehavesLikeResource(with: "show_transaction.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID,
                                                                                                     transactionID: transactionID,
                                                                                                     expandOptions: expandOptions,
                                                                                                     completion: completion) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: transactionPath, query: ["expand[]": "all"]) && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Transaction.self))
            }
            describe("send") {
                let parameters = SendTransactionParameters(to: "address",
                                                           amount: "0.000001",
                                                           currency: "BTC",
                                                           description: "Notes to be included in the email that the recipient receives",
                                                           skipNotifications: false,
                                                           fee: "0.0005",
                                                           idem: "A token to ensure idempotence.",
                                                           toFinancialInstitiution: true,
                                                           financialInstitutionWebsite: "The website of the financial institution or exchange.")
                let twoFactorAuthToken = "2fa_token"
                itBehavesLikeResource(with: "send_money_confirmed.json",
                                      requestedBy: { completion in
                                        transactionResource().send(accountID: accountID,
                                                                   twoFactorAuthToken: twoFactorAuthToken,
                                                                   expandOptions: expandOptions,
                                                                   parameters: parameters,
                                                                   completion: completion) },
                                      expectationsForRequest: request(ofMethod: .post) && url(withPath: transactionsPath, query: ["expand[]": "all"]) && hasAuthorization()
                                        && validHTTPBody(parameters: parameters) && containsHeaders(headers: [HeaderKeys.cb2FA: twoFactorAuthToken]),
                                      expectationsForResult: successfulResult(ofType: Transaction.self))
            }
            describe("request") {
                let parameters = RequestTransactionParameters(to: "String",
                                                              amount: "0.000001",
                                                              currency: "BTC",
                                                              description: "Notes to be included in the email that the recipient receives")
                itBehavesLikeResource(with: "request_money.json",
                                      requestedBy: { completion in transactionResource().request(accountID: accountID,
                                                                                                 expandOptions: expandOptions,
                                                                                                 parameters: parameters,
                                                                                                 completion: completion) },
                                      expectationsForRequest: request(ofMethod: .post) &&
                                        validHTTPBody(parameters: parameters) &&
                                        url(withPath: transactionsPath, query: ["expand[]": "all"]) && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Transaction.self))
            }
            describe("completeRequest") {
                itBehavesLikeResource(with: "send_money_confirmed.json",
                                      requestedBy: { completion in transactionResource().completeRequest(accountID: accountID,
                                                                                                         transactionID: transactionID,
                                                                                                         expandOptions: expandOptions,
                                                                                                         completion: completion) },
                                      expectationsForRequest: request(ofMethod: .post) &&
                                        url(withPath: "\(transactionPath)/complete") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Transaction.self))
            }
            describe("resendRequest") {
                itBehavesLikeResource(with: "request_money.json",
                                      requestedBy: { completion in transactionResource().resendRequest(accountID: accountID,
                                                                                                       transactionID: transactionID,
                                                                                                       expandOptions: expandOptions,
                                                                                                       completion: completion) },
                                      expectationsForRequest: request(ofMethod: .post) &&
                                        url(withPath: "\(transactionPath)/resend", query: ["expand[]": "all"]) && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: Transaction.self))
            }
            describe("cancelRequest") {
                itBehavesLikeResource(with: "empty.json",
                                      requestedBy: { completion in transactionResource().cancelRequest(accountID: accountID,
                                                                                                       transactionID: transactionID,
                                                                                                       completion: completion) },
                                      expectationsForRequest: request(ofMethod: .delete) &&
                                        url(withPath: transactionPath) && hasAuthorization(),
                                      expectationsForResult: successfulEmptyResult())
            }
        }
    }
    
    func validHTTPBody(parameters: TransactionParameters) -> URLRequestExpectation {
        return hasBody(parameters: ["type": parameters.type,
                                    "to": parameters.to,
                                    "amount": parameters.amount,
                                    "currency": parameters.currency,
                                    "description": parameters.description])
    }
    
    func validHTTPBody(parameters: SendTransactionParameters) -> URLRequestExpectation {
        return hasBody(parameters: ["type": parameters.type,
                                    "to": parameters.to,
                                    "amount": parameters.amount,
                                    "currency": parameters.currency,
                                    "skip_notifications": parameters.skipNotifications.map { $0 ? 1 : 0 },
                                    "fee": parameters.fee,
                                    "idem": parameters.idem,
                                    "to_financial_institution": parameters.toFinancialInstitiution.map { $0 ? 1 : 0 },
                                    "financial_institution_website": parameters.financialInstitutionWebsite,
                                    "description": parameters.description])
    }
    
    func containsHeaders(headers: [String: String]) -> URLRequestExpectation {
        return { request in
            guard !headers.isEmpty else {
                return
            }
            if headers.contains(where: { (key, value) in request.allHTTPHeaderFields?[key] != value }) {
                fail("Missing requested header")
                return
            }
        }
    }
    
}

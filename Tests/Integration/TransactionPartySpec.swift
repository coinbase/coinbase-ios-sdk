//
//  TransactionPartySpec.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class TransactionPartySpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        super.spec()
        
        let accountID = StubConstants.accountID
        let transactionID = StubConstants.transactionID
        
        let user = User(id: "user_id", resourcePath: "user/user_id")
        let cryptoAddress = CryptoAddress(resource: "bitcoin_address", addressInfo: AddressInfo(address: "address"))
        let email = EmailModel(email: "email@email.com")
        let account = Account(id: StubConstants.accountID, resourcePath: "account_path")
        describe("TransactionParty") {
            let transactionResource = specVar { Coinbase(accessToken: StubConstants.accessToken).transactionResource }
            describe("transactionToUser") {
                itBehavesLikeResource(with: "transaction_to_user.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && to(party: .user(user)))
            }
            describe("transactionFromUser") {
                itBehavesLikeResource(with: "transaction_from_user.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && from(party: .user(user)))
            }
            describe("transactionToBTCAddress") {
                itBehavesLikeResource(with: "transaction_to_btc_address.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && to(party: .cryptoAddress(cryptoAddress)))
            }
            describe("transactionFromBTCAddress") {
                itBehavesLikeResource(with: "transaction_from_btc_address.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && from(party: .cryptoAddress(cryptoAddress)))
            }
            describe("transactionToEmail") {
                itBehavesLikeResource(with: "transaction_to_email.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && to(party: .email(email)))
            }
            describe("transactionFromEmail") {
                itBehavesLikeResource(with: "transaction_from_email.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && from(party: .email(email)))
            }
            describe("transactionToAccount") {
                itBehavesLikeResource(with: "transaction_to_account.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && to(party: .account(account)))
            }
            describe("transactionFromAccount") {
                itBehavesLikeResource(with: "transaction_from_account.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: successfulResult(ofType: Transaction.self) && from(party: .account(account)))
            }
            describe("transactionToUnsupportedParty") {
                itBehavesLikeResource(with: "transaction_to_unsupported_party.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: invalid(result:))
            }
            describe("transactionFromUnsupportedParty") {
                itBehavesLikeResource(with: "transaction_from_unsupported_party.json",
                                      requestedBy: { completion in transactionResource().transaction(accountID: accountID, transactionID: transactionID, completion: completion) },
                                      expectationsForRequest: { _ in },
                                      expectationsForResult: invalid(result:))
            }
        }
    }
    
    func invalid(result: Result<Transaction>) {
        expect(result).notTo(beSuccessful())
    }
    
    func to(party: TransactionParty) -> ResultExpectation<Transaction> {
        return { result in
            self.check(lhParty: party, rhParty: result.value!.to!)
        }
    }
    
    func from(party: TransactionParty) -> ResultExpectation<Transaction> {
        return { result in
            self.check(lhParty: party, rhParty: result.value!.from!)
        }
    }
    
    func check(lhParty: TransactionParty, rhParty: TransactionParty) {
        expect({
            switch (lhParty, rhParty) {
            case (.account, .account),
                 (.user, .user),
                 (.email, .email),
                 (.cryptoAddress, .cryptoAddress):
                return .succeeded
            default:
                return .failed(reason: "Unexpected TransactionParty")
            }
        }).to(succeed())
    }
    
}

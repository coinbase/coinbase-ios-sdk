//
//  TokenResourceSpec.swift
//  CoinbaseTests
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

class TokenResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("TokenResource") {
            var token: String?
            let sessionManager = specVar { SessionManager() }
            let coinbase = specVar { Coinbase(accessToken: token, sessionManager: sessionManager()) }
            let tokenResource = specVar { coinbase().tokenResource }
            
            let code = "someCode"
            let clientID = StubConstants.clientID
            let redirectURI = "someRedirectURI"
            let clientSecret = StubConstants.clientSecret
            let refreshToken = "refreshToken"
            
            describe("get") {
                beforeEach {
                    token = nil
                }
                let expectedParameters = ["grant_type": "authorization_code",
                                          "code": code,
                                          "client_id": clientID,
                                          "client_secret": clientSecret,
                                          "redirect_uri": redirectURI]
                itBehavesLikeResource(with: "token.json",
                                      requestedBy: { comp in tokenResource().get(code: code,
                                                                                 clientID: clientID,
                                                                                 clientSecret: clientSecret,
                                                                                 redirectURI: redirectURI,
                                                                                 completion: comp) },
                                      expectationsForRequest: request(ofMethod: .post)
                                        && url(withPath: "/oauth/token")
                                        && hasBody(parameters: expectedParameters),
                                      expectationsForResult: valid(result:))
                it("store access token") {
                    expect(coinbase().accessToken).to(beNil())
                    make({ comp in tokenResource().get(code: code,
                                                       clientID: clientID,
                                                       clientSecret: clientSecret,
                                                       redirectURI: redirectURI,
                                                       completion: comp) })
                    expect(coinbase().accessToken).notTo(beNil())
                }
            }
            describe("refresh") {
                beforeEach {
                    token = nil
                }
                let expectedParameters = ["grant_type": "refresh_token",
                                          "refresh_token": refreshToken,
                                          "client_id": clientID,
                                          "client_secret": clientSecret]
                itBehavesLikeResource(with: "token.json",
                                      requestedBy: { comp in tokenResource().refresh(clientID: clientID,
                                                                                     clientSecret: clientSecret,
                                                                                     refreshToken: refreshToken,
                                                                                     completion: comp) },
                                      expectationsForRequest: request(ofMethod: .post)
                                        && url(withPath: "/oauth/token")
                                        && hasBody(parameters: expectedParameters),
                                      expectationsForResult: valid(result:))
                it("store access token") {
                    expect(coinbase().accessToken).to(beNil())
                    make({ comp in tokenResource().refresh(clientID: clientID,
                                                           clientSecret: clientSecret,
                                                           refreshToken: refreshToken,
                                                           completion: comp) })
                    expect(coinbase().accessToken).notTo(beNil())
                }
            }
            describe("revoke") {
                beforeEach {
                    token = StubConstants.accessToken
                }
                itBehavesLikeResource(with: "empty.json",
                                      requestedBy: { comp in tokenResource().revoke(accessToken: token!, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .post)
                                        && url(withPath: "/oauth/revoke") && hasBody(parameters: ["token": StubConstants.accessToken]),
                                      expectationsForResult: successfulEmptyResult())
                it("reset access token") {
                    make({ comp in tokenResource().revoke(accessToken: token!, completion: comp) })
                    expect(coinbase().accessToken).to(beNil())
                }
            }
        }
    }
    
    func valid(result: Result<UserToken>) {
        expect(result).to(beSuccessful())
        expect(result.value?.accessToken).notTo(beEmpty())
        expect(result.value?.scope).notTo(beEmpty())
    }
    
}

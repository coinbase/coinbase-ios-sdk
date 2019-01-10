//
//  RefreshTokenSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

private let newAccessToken = "some_token"
private let newRefreshToken = "some_refresh"

class RefreshTokenSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        describe("Coinbase") {
            var coinbase = Coinbase()
            describe("autoRefresh handling") {
                context("when token expired") {
                    let expiredToken = "expiredToken"
                    let requestResult = specVar { getResult(with: coinbase) }
                    beforeEach {
                        stubTokenRequest()
                        stubRequstWithTokenCheck()
                    }
                    context("when autoRefresh not provided") {
                        beforeEach {
                            coinbase = Coinbase(accessToken: expiredToken)
                        }
                        it("return error") {
                            expect(requestResult()).to(beFailed())
                        }
                    }
                    context("when autoRefresh provided") {
                        
                        context("when token can be refreshed") {
                            var newToken: UserToken?
                            beforeEach {
                                coinbase = Coinbase()
                                coinbase.setRefreshStrategy(.refresh(clientID: StubConstants.clientID,
                                                                     clientSecret: StubConstants.clientSecret,
                                                                     refreshToken: "refresh",
                                                                     onUserTokenUpdate: { newToken = $0 }))
                                coinbase.accessToken = expiredToken
                                newToken = nil
                            }
                            it("refresh token and retry request") {
                                expect(requestResult()).to(beSuccessful())
                            }
                            it("update token on coinbase SessionManager") {
                                _ = requestResult()
                                expect(coinbase.accessToken).to(equal(newAccessToken))
                            }
                            it("send new token to onTokenRefresh closure") {
                                _ = requestResult()
                                expect(newToken?.refreshToken).to(equal(newRefreshToken))
                            }
                            
                            context("when multiple requests try to refresh token") {
                                it("allow only one refresh at a time") {
                                    var firstResult: Result<User>?
                                    var secondResult: Result<User>?
                                    waitUntil { done in
                                        coinbase.userResource.current(completion: {
                                            firstResult = $0
                                            if firstResult != nil && secondResult != nil {
                                                done()
                                            }
                                        })
                                        coinbase.userResource.current(completion: {
                                            secondResult = $0
                                            if firstResult != nil && secondResult != nil {
                                                done()
                                            }
                                        })
                                    }
                                    expect(firstResult).to(beSuccessful())
                                    expect(secondResult).to(beSuccessful())
                                }
                            }
                            
                        }
                        context("when token cannot be refreshed") {
                            beforeEach {
                                coinbase = Coinbase()
                                coinbase.setRefreshStrategy(.refresh(clientID: StubConstants.clientID,
                                                                     clientSecret: StubConstants.clientSecret,
                                                                     refreshToken: "wrongRefresh",
                                                                     onUserTokenUpdate: { _ in  }))
                                coinbase.accessToken = expiredToken
                            }
                            it("returns Auth Error") {
                                expect(requestResult()).to(beFailed())
                                expect({
                                    guard let error = requestResult().error as? OAuthError,
                                        case let .responseError(errorData, code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(401))
                                    expect(errorData.error).to(equal(ClientErrorID.invalidRequest))
                                    return .succeeded
                                }).to(succeed())
                            }
                            it("clear coinbase accessToken Auth Error") {
                                expect(requestResult()).to(beFailed())
                                expect(coinbase.accessToken).to(beNil())
                            }
                        }
                    }
                }
            }
        }
    }

}

private func getResult(with coinbase: Coinbase) -> Result<User> {
    var result: Result<User>!
    waitUntil { done in
        coinbase.userResource.current(completion: {
            result = $0
            done()
        })
    }
    return result
}

private func stubTokenRequest() {
    var validRefresh = "refresh"
    stub(condition: pathEndsWith("/oauth/token"), response: { request in
        let json = (try? JSONSerialization.jsonObject(with: request.ohhttpStubs_httpBody!, options: [])).flatMap { $0 as? [String: String] }
        guard json?["refresh_token"] == validRefresh else {
            return fixture(filePath: OHPathForFile("oauth_error.json", CoinbaseSpec.self)!, status: 401, headers: nil)
        }
        validRefresh = newRefreshToken
        return fixture(filePath: OHPathForFile("token.json", CoinbaseSpec.self)!, headers: nil)
    })
}

private func stubRequstWithTokenCheck() {
    stub(condition: pathEndsWith("/user"), response: { requst in
        if requst.value(forHTTPHeaderField: HeaderKeys.authorization)?.contains("expiredToken") ?? false {
            return fixture(filePath: OHPathForFile("expired_token.json", CoinbaseSpec.self)!, status: 401, headers: nil)
        } else {
            return fixture(filePath: OHPathForFile("auth_user.json", CoinbaseSpec.self)!, headers: nil)
        }
    })
}

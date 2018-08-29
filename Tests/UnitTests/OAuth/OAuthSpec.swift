//
//  OAuthSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble

struct RedirectURIsValidatorForTests: RedirectURIsValidatorProtocol {
    let bundle = Bundle(for: OAuthSpec.self)
}

// swiftlint:disable type_body_length
class OAuthSpec: QuickSpec {
    
    override func spec() {
        describe("OAuth") {
            let mockedSessionManager = specVar { MockedSessionManager() }
            let coinbase = specVar { Coinbase(sessionManager: mockedSessionManager()) }
            let oauth = specVar { () -> OAuth in
                coinbase().oauth.redirectURIsValidator = RedirectURIsValidatorForTests()
                return coinbase().oauth
            }
            
            let clientID = StubConstants.clientID
            let clientSecret = StubConstants.clientSecret
            let redirectURI = "scheme://redirect.uri"
            let deeplinkURI = "scheme://deeplinkURI"
            let notRegisteredRedirectURI = "not.registered.redirect.scheme://redirect.uri"
            let notRegisteredDeeplinkURI = "not.registered.deeplink.scheme://deeplinkURI"
            let notRedirectURI = "fake_scheme://redirect.uri"
            let notDeeplinkURI = "fake_scheme://deeplinkURI"
            
            let code = "_code_"
            let state = "state"
            let incorrectState = "state2"
            
            let openURLString = "\(redirectURI)?code=\(code)&state=\(state)&parameter=value"
            
            let mockedURLOpener = specVar { MockedURLOpener() }
            
            describe("setup") {
                beforeEach {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
                }
                it("configured correctly") {
                    try? oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener()))
                    
                    guard let url = mockedURLOpener().openedURL else {
                        fail("URL is empty")
                        return
                    }
                    
                    let queryItems = URLComponents(string: url.absoluteString)?.queryItems
                    expect(queryItems).to(contain(URLQueryItem(name: "client_id", value: clientID)))
                    expect(queryItems).to(contain(URLQueryItem(name: "redirect_uri", value: redirectURI)))
                }
            }
            describe("isDeeplinkRedirect") {
                describe("when configured") {
                    beforeEach {
                        oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: deeplinkURI)
                    }
                    it("return true for deeplinkURI") {
                        let deeplinkURL = URL(string: deeplinkURI)!
                        expect(oauth().isDeeplinkRedirect(url: deeplinkURL)).to(beTrue())
                    }
                    it("return false for redirectURI") {
                        let deeplinkURL = URL(string: redirectURI)!
                        expect(oauth().isDeeplinkRedirect(url: deeplinkURL)).to(beFalse())
                    }
                }
                describe("when not configured") {
                    it("return false for deeplinkURI") {
                        let deeplinkURL = URL(string: deeplinkURI)!
                        expect(oauth().isDeeplinkRedirect(url: deeplinkURL)).to(beFalse())
                    }
                }
            }
            describe("redirect URIs validator") {
                it("throw an error when redirect URIs are not registered") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: deeplinkURI)
                    oauth().redirectURIsValidator = RedirectURIsValidator()
                    let expectedError = OAuthError.notRegisteredSchemes(schemes: ["scheme"])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when redirectURI is not registered") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: notRegisteredRedirectURI, deeplinkURI: deeplinkURI)
                    let expectedError = OAuthError.notRegisteredSchemes(schemes: ["not.registered.redirect.scheme"])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when deeplinkURI is not registered") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: notRegisteredDeeplinkURI)
                    let expectedError = OAuthError.notRegisteredSchemes(schemes: ["not.registered.deeplink.scheme"])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when redirectURI and deeplinkURI are not registered") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: notRegisteredRedirectURI, deeplinkURI: notRegisteredDeeplinkURI)
                    let expectedError = OAuthError.notRegisteredSchemes(schemes: ["not.registered.redirect.scheme",
                                                                                  "not.registered.deeplink.scheme"])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when redirectURI is invalid") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: notRedirectURI)
                    let expectedError = OAuthError.invalidURIs(uris: [notRedirectURI])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when deeplinkURI is invalid") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: notDeeplinkURI)
                    let expectedError = OAuthError.invalidURIs(uris: [notDeeplinkURI])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when redirectURI and deeplinkURI are invalid") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: notRedirectURI, deeplinkURI: notDeeplinkURI)
                    let expectedError = OAuthError.invalidURIs(uris: [notRedirectURI, notDeeplinkURI])
                    expect { try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener())) }.to(throwError(expectedError))
                    expect(mockedURLOpener().openedURL).to(beNil())
                }
                it("throw an error when redirectURI and deeplinkURI are valid") {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: deeplinkURI)
                    let state = "random_state"
                    let oauthKeys = OAuthKeys(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: deeplinkURI)
                    let authorizationURL = OAuthURLBuilder.authorizationURL(oauthKeys: oauthKeys, state: state)
                    let expectedError = OAuthError.cantRedirectTo(url: authorizationURL)
                    expect { try oauth().beginAuthorization(state: state, flowType: .inApp(from: UIViewController())) }.to(throwError(expectedError))
                }
            }
            context("when configured") {
                beforeEach {
                    oauth().configure(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI)
                }
                describe("when pass all parameters") {
                    let layout = Layout.signup
                    let scopes = ["scope1", "scope2"]
                    let accountCurrency = ["BTC", "LTC"]
                    let accessType: AccountAccess = .selectFromCurrency(accountCurrency)
                    let meta = ["meta_key": "meta_value",
                                "meta_key2": "meta_value2"]
                    
                    var components: URLComponents!
                    var queryItems: [URLQueryItem]!
                    beforeEach {
                        try? oauth().beginAuthorization(layout: layout,
                                                        scope: scopes,
                                                        state: state,
                                                        account: accessType,
                                                        meta: meta,
                                                        flowType: .with(opener: mockedURLOpener()))
                        guard let urlString = mockedURLOpener().openedURL?.absoluteString,
                            let urlComponents = URLComponents(string: urlString) else {
                                fail("Built URL is empty")
                                return
                        }
                        components = urlComponents
                        guard let items = components.queryItems else {
                            fail("Built URL is missing required query parameters")
                            return
                        }
                        queryItems = items
                    }
                    it("contain correct base URL") {
                        expect(components.scheme).to(equal(OAuthConstants.AuthorizationURL.scheme))
                        expect(components.host).to(equal(OAuthConstants.AuthorizationURL.host))
                        expect(components.path).to(equal(OAuthConstants.AuthorizationURL.path))
                    }
                    it("contain correct layout") {
                        expect(queryItems).to(contain(URLQueryItem(name: "layout", value: "signup")))
                    }
                    it("contain correct respose type") {
                        expect(queryItems).to(contain(URLQueryItem(name: "response_type", value: "code")))
                    }
                    it("contain correct client id") {
                        expect(queryItems).to(contain(URLQueryItem(name: "client_id", value: clientID)))
                    }
                    it("contain correct redirect URI") {
                        expect(queryItems).to(contain(URLQueryItem(name: "redirect_uri", value: redirectURI.removingPercentEncoding)))
                    }
                    it("contain correct state") {
                        expect(queryItems).to(contain(URLQueryItem(name: "state", value: state)))
                    }
                    it("contain correct account") {
                        expect(queryItems).to(contain(URLQueryItem(name: "account", value: accessType.stringValue)))
                    }
                    it("contain correct scope") {
                        let scopeString = scopes.joined(separator: ",")
                        expect(queryItems).to(contain(URLQueryItem(name: "scope", value: scopeString)))
                    }
                    it("contain correct account currency") {
                        let currencyString = accountCurrency.joined(separator: ",")
                        expect(queryItems).to(contain(URLQueryItem(name: "account_currency", value: currencyString)))
                    }
                    it("contain correct meta parameters") {
                        meta.forEach { arg in
                            expect(queryItems).to(contain(URLQueryItem(name: "meta[\(arg.key)]", value: arg.value)))
                        }
                        
                    }
                }
                describe("beginAuthorization") {
                    context("when URLOpener cant open url") {
                        beforeEach {
                            mockedURLOpener().allowURLOpenning = false
                        }
                        it("throws error") {
                            var returnedError: Error?
                            do {
                                try oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener()))
                            } catch {
                                returnedError = error
                            }
                            expect(mockedURLOpener().openedURL).to(beNil())
                            expect(returnedError).notTo(beNil())
                        }
                    }
                    context("when URLOpener can open url") {
                        it("open url") {
                            try? oauth().beginAuthorization(flowType: .with(opener: mockedURLOpener()))
                            expect(mockedURLOpener().openedURL).toNot(beNil())
                        }
                    }
                }
                
                describe("completeAuthorization") {
                    context("when url to open is not supported") {
                        it("fail to complete authorization", closure: {
                            let openURL = URL(string: notRedirectURI)!
                            let canComplete = oauth().completeAuthorization(openURL) { result in
                                expect({
                                    guard case .some(.cantHandleURL(_)) = result.error as? OAuthError else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    return .succeeded
                                }).to(succeed())
                            }
                            expect(canComplete).to(beFalse())
                        })
                    }
                    context("when url to open has no parameters") {
                        it("fail to complete authorization", closure: {
                            let openURL = URL(string: redirectURI)!
                            let canComplete = oauth().completeAuthorization(openURL) { result in
                                expect(result.error).toNot(beNil())
                            }
                            expect(canComplete).to(beTrue())
                        })
                    }
                    context("when url to open has no required parameters") {
                        it("fail to complete authorization", closure: {
                            let openURL = URL(string: "\(redirectURI)?paremeter=value")!
                            let canComplete = oauth().completeAuthorization(openURL) { result in
                                expect(result.error).toNot(beNil())
                            }
                            expect(canComplete).to(beTrue())
                        })
                    }
                    context("when url to open has an incorrect state") {
                        it("fail to complete authorization", closure: {
                            let openURL = URL(string: openURLString)!
                            try? oauth().beginAuthorization(state: incorrectState, flowType: .with(opener: mockedURLOpener()))
                            let canComplete = oauth().completeAuthorization(openURL) { result in
                                expect(result.error).toNot(beNil())
                            }
                            expect(canComplete).to(beTrue())
                        })
                    }
                    context("when url to open is supported") {
                        it("succeed in completing authorization", closure: {
                            let openURL = URL(string: openURLString)!
                            try? oauth().beginAuthorization(state: state, flowType: .with(opener: mockedURLOpener()))
                            let canComplete = oauth().completeAuthorization(openURL) { _ in }
                            expect(canComplete).to(beTrue())
                            let expectedAPI = mockedSessionManager().lastRequest as? TokensAPI
                            expect({
                                guard case .some(.get) = expectedAPI else { return .wrongEnumCase }
                                return .succeeded
                            }).to(succeed())
                        })
                    }
                }
            }
            
            context("not configured") {
                describe("beginAuthorization") {
                    it("begin with success") {
                        expect { try oauth().beginAuthorization() }.to(throwError(OAuthError.configurationMissing))
                    }
                }
                
                describe("completeAuthorization") {
                    context("when url to open is supported") {
                        it("fail to complete authorization", closure: {
                            let openURL = URL(string: openURLString)!
                            try? oauth().beginAuthorization(state: state, flowType: .with(opener: mockedURLOpener()))
                            let canComplete = oauth().completeAuthorization(openURL) { result in
                                expect(result.error).toNot(beNil())
                            }
                            expect(canComplete).to(beFalse())
                        })
                    }
                }
            }
        }
    }
    
}
// swiftlint:enable type_body_length

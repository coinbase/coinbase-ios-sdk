//
//  OAuthURLBuilderSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc.. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class OAuthURLBuilderSpec: QuickSpec {
    
    override func spec() {
        describe("OAuthURLBuilder") {
            let clientID = StubConstants.clientID
            let clientSecret = StubConstants.clientSecret
            let redirectURI = "scheme://redirect.uri"
            let oauthKeys = OAuthKeys(clientID: clientID, clientSecret: clientSecret, redirectURI: redirectURI, deeplinkURI: nil)
            
            describe("when pass all parameters") {
                let layout = Layout.signup
                let scopes = ["scope1", "scope2"]
                let state = "state"
                let accountCurrency = ["BTC", "LTC"]
                let accessType: AccountAccess = .selectFromCurrency(accountCurrency)
                let meta = ["meta_key": "meta_value",
                            "meta_key2": "meta_value2"]
                
                var components: URLComponents!
                var queryItems: [URLQueryItem]!
                beforeEach {
                    let builtURL = OAuthURLBuilder.authorizationURL(oauthKeys: oauthKeys,
                                                                    layout: layout,
                                                                    scope: scopes,
                                                                    state: state,
                                                                    accountAccess: accessType,
                                                                    meta: meta)
                    guard let urlString = builtURL?.absoluteString,
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
            describe("when pass AccountAccess all") {
                let accessType: AccountAccess = .all
                
                var components: URLComponents!
                var queryItems: [URLQueryItem]!
                beforeEach {
                    let builtURL = OAuthURLBuilder.authorizationURL(oauthKeys: oauthKeys,
                                                                    accountAccess: accessType)
                    guard let urlString = builtURL?.absoluteString,
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
                it("contain correct account") {
                    expect(queryItems).to(contain(URLQueryItem(name: "account", value: accessType.stringValue)))
                }
                it("contain correct account currency") {
                    expect(queryItems).toNot(contain(URLQueryItem(name: "account_currency", value: nil)))
                }
                it("doesn't contain layout parameter") {
                    expect(queryItems).toNot(contain(URLQueryItem(name: "layout", value: "signup")))
                }
            }
        }
    }
    
}

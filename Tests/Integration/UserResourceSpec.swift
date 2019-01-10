//
//  UserSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class UserResourceSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {        
        describe("UserResource") {
            let userResource = specVar { Coinbase(accessToken: StubConstants.accessToken).userResource }
            describe("current") {
                itBehavesLikeResource(with: "auth_user.json",
                                      requestedBy: { comp in userResource().current(completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/user") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: User.self))
            }
            
            describe("get(by: ") {
                let userID = "user_id"
                itBehavesLikeResource(with: "user_by_id.json",
                                      requestedBy: { comp in userResource().get(by: userID, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/users/\(userID)") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: User.self))
            }
            
            describe("authorizationInfo") {
                itBehavesLikeResource(with: "auth_info.json",
                                      requestedBy: { comp in userResource().authorizationInfo(completion: comp) },
                                      expectationsForRequest: request(ofMethod: .get) && url(withPath: "/user/auth") && hasAuthorization(),
                                      expectationsForResult: successfulResult(ofType: AuthorizationInfo.self))
            }
            
            describe("updateCurrent") {
                let newName = "newName"
                let timeZone = "newTimeZone"
                let nativeCurrency = "newNativeCurrency"
                let expectedBody = [
                    "name": newName,
                    "time_zone": timeZone,
                    "native_currency": nativeCurrency
                ]
                itBehavesLikeResource(with: "auth_user.json",
                                      requestedBy: { comp in userResource().updateCurrent(name: newName, timeZone: timeZone, nativeCurrency: nativeCurrency, completion: comp) },
                                      expectationsForRequest: request(ofMethod: .put) && url(withPath: "/user") && hasAuthorization() && hasBody(parameters: expectedBody),
                                      expectationsForResult: successfulResult(ofType: User.self))
            }
        }
    }
    
}

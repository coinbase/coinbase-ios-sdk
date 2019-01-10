//
//  ErrorsSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class ResponseSerializationErrorSpec: QuickSpec {
    
    override func spec() {
        describe("ResponseSerializationError") {
            describe("incorrectResponseType") {
                let error = ResponseSerializationError.incorrectResponseType
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("unacceptableStatusCode") {
                let statusCode = 11111111
                let error = ResponseSerializationError.unacceptableStatusCode(statusCode)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("inputDataEmpty") {
                let error = ResponseSerializationError.inputDataEmpty
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
        }
    }
    
}

class NetworkErrorSpec: QuickSpec {
    
    override func spec() {
        describe("NetworkError") {
            let uri = "scheme://base.url"
            describe("invalidBaseURL") {
                let error = NetworkError.invalidBaseURL(uri)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("invalidEnvironmentData") {
                let error = NetworkError.invalidEnvironmentData(URLComponents(string: uri)!)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("emptyAccessToken") {
                let request = URLRequest(url: URL(string: uri)!)
                let error = NetworkError.emptyAccessToken(request)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("emptyRefreshToken") {
                let error = NetworkError.emptyRefreshToken
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("responseError") {
                let statusCode = 11111111
                let errorResponseString = "{\"errors\": []}"
                let errorResponseData = errorResponseString.data(using: .utf8)!
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: errorResponseData)
                
                let error = NetworkError.responseError(errorResponse!, statusCode: statusCode)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
        }
    }
    
}

class OAuthErrorSpec: QuickSpec {
    
    override func spec() {
        describe("OAuthError") {
            let uri = "scheme://base.url"
            let scheme = "scheme"
            let url = URL(string: uri)!
            describe("configurationMissing") {
                let error = OAuthError.configurationMissing
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("invalidURIs") {
                let error = OAuthError.invalidURIs(uris: [uri])
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("notRegisteredSchemes") {
                let error = OAuthError.notRegisteredSchemes(schemes: Set([scheme]))
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("cantRedirectTo") {
                let error = OAuthError.cantRedirectTo(url: url)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("cantHandleURL") {
                let error = OAuthError.cantHandleURL(url: url)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("malformedResponse") {
                let error = OAuthError.malformedResponse(url: url)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("incorrectStateParameterInResponse") {
                let state = "random_state"
                let expectedState = "expected_state"
                let error = OAuthError.incorrectStateParameterInResponse(state: state, expectedState: expectedState)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("missingCodeParameterInResponse") {
                let error = OAuthError.missingCodeParameterInResponse(url: url)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
            describe("responseError") {
                let statusCode = 11111111
                let errorResponseString = "{\"error\": \"test_error\",\"error_description\": \"test_description\"}"
                let errorResponseData = errorResponseString.data(using: .utf8)!
                let errorResponse = try? JSONDecoder().decode(OAuthErrorResponse.self, from: errorResponseData)
                
                let error = OAuthError.responseError(errorResponse!, statusCode: statusCode)
                it("description is not empty") {
                    expect(error.errorDescription).toNot(beEmpty())
                }
            }
        }
    }
    
}

extension OAuthError: Equatable {
    
    static public func == (lhs: OAuthError, rhs: OAuthError) -> Bool {
        switch (lhs, rhs) {
        case (.configurationMissing, .configurationMissing):
            return true
        case (.invalidURIs(let lhsURIs), .invalidURIs(let rhsURIs)):
            return lhsURIs == rhsURIs
        case (.notRegisteredSchemes(let lhsSchemes), .notRegisteredSchemes(let rhsSchemes)):
            return lhsSchemes == rhsSchemes
        case (.cantRedirectTo(let lhsURL), .cantRedirectTo(let rhsURL)):
            return lhsURL == rhsURL
        case (.cantHandleURL(let lhsURL), .cantHandleURL(let rhsURL)),
             (.malformedResponse(let lhsURL), .malformedResponse(let rhsURL)),
             (.missingCodeParameterInResponse(let lhsURL), .missingCodeParameterInResponse(let rhsURL)):
            return lhsURL == rhsURL
        case (let .incorrectStateParameterInResponse(lhsState, lhsExpectedState),
              let .incorrectStateParameterInResponse(rhsState, rhsExpectedState)):
            return lhsState == rhsState && lhsExpectedState == rhsExpectedState
        case (let .responseError(lhsErrorResponse, lhsStatusCode), let .responseError(rhsErrorResponse, rhsStatusCode)):
            return lhsErrorResponse == rhsErrorResponse && lhsStatusCode == rhsStatusCode
        default:
            return false
        }
    }
    
}

// MARK: - Extension conforming to Equatable

extension OAuthErrorResponse: Equatable {
    
    public static func == (lhs: OAuthErrorResponse, rhs: OAuthErrorResponse) -> Bool {
        return lhs.error == rhs.error && lhs.description == lhs.description
    }
    
}

//
//  ErrorHandlingSpec.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

class ErrorHandlingSpec: QuickSpec, IntegrationSpecProtocol {
    
    override func spec() {
        describe("Network layer") {
            let sessionManager = specVar { return SessionManager() }
            context("when create request") {
                context("when base url invalid") {
                    let invalidBaseURL = "%%%"
                    it("return NetworkError.invalidBaseURL error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpoint, baseURL: invalidBaseURL) { (result: Result<Data>) in
                            expect(result).to(beFailed(with: NetworkError.self))
                            guard let error = result.error as? NetworkError else { return }
                            expect({
                                guard case let .invalidBaseURL(url) = error else {
                                    return .failed(reason: "wrong enum case")
                                }
                                expect(url).to(equal(invalidBaseURL))
                                return .succeeded
                            }).to(succeed())
                        }
                    }
                }
                context("when url cannot be created") {
                    let invalidBaseURL = ""
                    it("return NetworkError.invalidEnvironmentData error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpointExpectingScheme, baseURL: invalidBaseURL) { (result: Result<Data>) in
                            expect(result).to(beFailed(with: NetworkError.self))
                            guard let error = result.error as? NetworkError else { return }
                            expect({
                                guard case NetworkError.invalidEnvironmentData(_) = error else {
                                    return .failed(reason: "wrong enum case")
                                }
                                return .succeeded
                            }).to(succeed())
                        }
                    }
                }
                context("when resource requires token and Session Manager has not token") {
                    it("return NetworkError emptyAccessToken error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpointWithToken) { (result: Result<Data>) in
                            expect(result).to(beFailed(with: NetworkError.self))
                            guard let error = result.error as? NetworkError else { return }
                            expect({
                                guard case .emptyAccessToken(_) = error else {
                                    return .failed(reason: "wrong enum case")
                                }
                                return .succeeded
                            }).to(succeed())
                        }
                    }
                }
            }
            context("when network error occured") {
                Stubs.noNetwork()
                it("return NSError with NSURLErrorDomain") {
                    expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                        expect(result).to(beFailed(with: NSError.self))
                        let error = result.error! as NSError
                        expect(error.domain).to(equal(NSURLErrorDomain))
                        expect(error.code).to(equal(URLError.notConnectedToInternet.rawValue))
                    }
                }
            }
            context("when request not allow empty responcse") {
                context("when response data is empty") {
                    Stubs.emptyData()
                    it("return ResponseSerializationError inputDataEmpty error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                            expect(result).to(beFailed(with: ResponseSerializationError.self))
                            guard let error = result.error as? ResponseSerializationError else { return }
                            expect({
                                guard case .inputDataEmpty = error else {
                                    return .failed(reason: "wrong enum case")
                                }
                                return .succeeded
                            }).to(succeed())
                        }
                    }
                }
                context("when response status code 204") {
                    Stubs.noContent()
                    it("return ResponseSerializationError inputDataEmpty error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                            expect(result).to(beFailed(with: ResponseSerializationError.self))
                            guard let error = result.error as? ResponseSerializationError else { return }
                            expect({
                                guard case .inputDataEmpty = error else {
                                    return .failed(reason: "wrong enum case")
                                }
                                return .succeeded
                            }).to(succeed())
                        }
                    }
                }
            }
            context("when response status code greater then 400") {
                context("when response has no data") {
                    Stubs.emptyData(status: 400)
                    context("when resource allow empty response") {
                        it("return ResponseSerializationError unacceptableStatusCode error") {
                            expectResults(by: sessionManager(), to: TestAPI.endpointAllowEmpty) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: ResponseSerializationError.self))
                                guard let error = result.error as? ResponseSerializationError else { return }
                                expect({
                                    guard case let .unacceptableStatusCode(code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(400))
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                    context("when resource not allow empty response") {
                        it("return ResponseSerializationError inputDataEmpty error") {
                            expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: ResponseSerializationError.self))
                                guard let error = result.error as? ResponseSerializationError else { return }
                                expect({
                                    guard case .inputDataEmpty = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                }
                context("when response contain oauth error") {
                    useStub(condition: anyRequest(), with: "oauth_error.json", status: 400)
                    context("when resource expect oauth error") {
                        it("return ResponseSerializationError unacceptableStatusCode error") {
                            expectResults(by: sessionManager(), to: TestAPI.oauthEndpoint) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: OAuthError.self))
                                guard let error = result.error as? OAuthError else { return }
                                expect({
                                    guard case let .responseError(errorData, code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(400))
                                    expect(errorData.error).notTo(beEmpty())
                                    expect(errorData.description).notTo(beEmpty())
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                    context("when resource expect general error") {
                        it("return ResponseSerializationError unacceptableStatusCode error") {
                            expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: ResponseSerializationError.self))
                                guard let error = result.error as? ResponseSerializationError else { return }
                                expect({
                                    guard case let .unacceptableStatusCode(code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(400))
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                }
                context("when response contain general error") {
                    useStub(condition: anyRequest(), with: "validation_error.json", status: 400)
                    context("when resource general error") {
                        it("return ResponseSerializationError unacceptableStatusCode error") {
                            expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: NetworkError.self))
                                guard let error = result.error as? NetworkError else { return }
                                expect({
                                    guard case let .responseError(errorData, code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(400))
                                    expect(errorData.errors).notTo(beEmpty())
                                    expect(errorData.errors.first?.id).notTo(beEmpty())
                                    expect(errorData.errors.first?.message).notTo(beEmpty())
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                    context("when resource expect oauth error") {
                        it("return ResponseSerializationError unacceptableStatusCode error") {
                            expectResults(by: sessionManager(), to: TestAPI.oauthEndpoint) { (result: Result<Data>) in
                                expect(result).to(beFailed(with: ResponseSerializationError.self))
                                guard let error = result.error as? ResponseSerializationError else { return }
                                expect({
                                    guard case let .unacceptableStatusCode(code) = error else {
                                        return .failed(reason: "wrong enum case")
                                    }
                                    expect(code).to(equal(400))
                                    return .succeeded
                                }).to(succeed())
                            }
                        }
                    }
                }
            }
            context("when response is malformed json") {
                useStub(condition: anyRequest(), with: "malformed.json")
                context("when expect convertion to model") {
                    it("return DecodingError dataCorrupted error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<TestModel>) in
                            expect(result).to(beFailed(with: DecodingError.self))
                        }
                    }
                }
                context("when use plain data") {
                    it("return error") {
                        expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<Data>) in
                            expect(result).to(beSuccessful())
                        }
                    }
                }
                
            }
            context("when response cannot be mapped to model") {
                Stubs.testData()
                it("return DecodingError keyNotFound error") {
                    expectResults(by: sessionManager(), to: TestAPI.endpoint) { (result: Result<TestModel>) in
                        expect(result).to(beFailed(with: DecodingError.self))
                    }
                }
            }
        }
    }
    
}

private enum TestAPI: ResourceAPIProtocol {
    
    case endpointWithToken
    case endpoint
    case endpointAllowEmpty
    case oauthEndpoint
    case endpointExpectingScheme
    case endpointInvalidJSON
    
    var path: String {
        switch self {
        case .endpointExpectingScheme: return "//base/enpoint"
        default: return "/enpoint"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .endpointInvalidJSON: return .post
        default: return .get
        }
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .endpointInvalidJSON: return .body(["not_serealizable_field": Data()])
        default: return nil
        }
    }
    
    var authentication: AuthenticationType {
        switch self {
        case .endpointWithToken: return .token
        default: return .none
        }
    }
    
    var allowEmptyResponse: Bool {
        switch self {
        case .endpointAllowEmpty: return true
        default: return false
        }
    }
    
    var errorResponseType: ErrorResponseType {
        switch self {
        case .oauthEndpoint: return .oauth
        default: return .general
        }
    }
    
}

private struct TestModel: Decodable, ConvertibleFromData {
    let testField: String
}

private class Stubs {
    static func noNetwork() {
        beforeEach {
            stub(condition: anyRequest(), response: { _ in
                let notConnectedError = NSError(domain: NSURLErrorDomain, code: URLError.notConnectedToInternet.rawValue)
                return OHHTTPStubsResponse(error: notConnectedError)
            })
        }
    }
    static func emptyData(status: Int32 = 200) {
        beforeEach {
            stub(condition: anyRequest(), response: { _ in
                return OHHTTPStubsResponse(data: Data(), statusCode: status, headers: nil)
            })
        }
    }
    static func noContent() {
        beforeEach {
            stub(condition: anyRequest(), response: { _ in
                return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
            })
        }
    }
    static func testData() {
        beforeEach {
            stub(condition: anyRequest(), response: { _ in
                return OHHTTPStubsResponse(jsonObject: ["notField": "someData"], statusCode: 200, headers: nil)
            })
        }
    }
}

private func expectResults<T>(by sessionManager: SessionManager,
                              to endpoint: ResourceAPIProtocol,
                              baseURL: String = NetworkConstants.baseURLv2,
                              expectations: @escaping ((Result<T>) -> Void)) where T: ConvertibleFromData {
        waitUntil { done in
            sessionManager.request(endpoint, baseURL: baseURL) { (result: Result<T>) in
                expectations(result)
                done()
            }
        }
}

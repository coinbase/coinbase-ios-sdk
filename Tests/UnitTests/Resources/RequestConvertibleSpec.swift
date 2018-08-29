//
//  RequestConvertibleSpec.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble

class RequestConvertibleSpec: QuickSpec {
    
    override func spec() {
        describe("RequestConvertible") {
            let expandQueryName = "expand[]"
            describe("ExpandOptions") {
                context("when there is no expand options") {
                    it("create valid request") {
                        let endpoint = ExpandOptionTestAPI.noExpandOptions
                        let request = try? endpoint.asURLRequest(baseURL: NetworkConstants.baseURLv2)
                        let components = RequestConvertibleSpec.components(from: request)
                        let queryItems = components.queryItems
                        expect(queryItems == nil || queryItems!.isEmpty).to(beTrue())
                        expect(request?.httpBody).to(beNil())
                    }
                }
                context("when there are a few expand options") {
                    it("create valid request") {
                        let expandOptions: [TestExpandOption] = [.from, .to]
                        let endpoint = ExpandOptionTestAPI.fewExpandOptions(expandOptions: expandOptions)
                        let request = try? endpoint.asURLRequest(baseURL: NetworkConstants.baseURLv2)
                        let components = RequestConvertibleSpec.components(from: request)
                        
                        let queryItems = components.queryItems
                        expect(queryItems != nil && !queryItems!.isEmpty).to(beTrue())
                        for expandOption in expandOptions {
                            expect(queryItems).to(contain(URLQueryItem(name: expandQueryName, value: expandOption.rawValue)))
                        }
                        expect(request?.httpBody).to(beNil())
                    }
                }
                context("when there are a few expand options and get params") {
                    it("create valid request") {
                        let expandOptions: [TestExpandOption] = [.from, .to]
                        let params = ["test_get_parameter": "test_get_parameter_value",
                                      "test_get_parameter_1": "test_get_parameter_value_1"]
                        
                        let endpoint = ExpandOptionTestAPI.fewExpandOptionsWithParams(expandOptions: expandOptions, params: params)
                        let request = try? endpoint.asURLRequest(baseURL: NetworkConstants.baseURLv2)
                        let components = RequestConvertibleSpec.components(from: request)
                        
                        let queryItems = components.queryItems
                        expect(queryItems != nil && !queryItems!.isEmpty).to(beTrue())
                        for expandOption in expandOptions {
                            expect(queryItems).to(contain(URLQueryItem(name: expandQueryName, value: expandOption.rawValue)))
                        }
                        for parameter in params {
                            expect(queryItems).to(contain(URLQueryItem(name: parameter.key, value: parameter.value)))
                        }
                        expect(request?.httpBody).to(beNil())
                    }
                }
                context("with expand option all") {
                    it("create valid request") {
                        let endpoint = ExpandOptionTestAPI.allExpandOptions
                        let request = try? endpoint.asURLRequest(baseURL: NetworkConstants.baseURLv2)
                        let components = RequestConvertibleSpec.components(from: request)
                        
                        let queryItems = components.queryItems
                        expect(queryItems != nil && !queryItems!.isEmpty).to(beTrue())
                        expect(queryItems).to(contain(URLQueryItem(name: expandQueryName, value: TestExpandOption.all.rawValue)))
                        expect(request?.httpBody).to(beNil())
                    }
                }
                context("with expand option all POST request") {
                    it("create valid request") {
                        let params = ["test_body_parameter": "test_body_parameter_value",
                                      "test_body_parameter_1": "test_body_parameter_value_1"]
                        
                        let endpoint = ExpandOptionTestAPI.allExpandOptionsPost(parameters: params)
                        let request = try? endpoint.asURLRequest(baseURL: NetworkConstants.baseURLv2)
                        let components = RequestConvertibleSpec.components(from: request)
                        
                        let queryItems = components.queryItems
                        expect(queryItems != nil && !queryItems!.isEmpty).to(beTrue())
                        expect(queryItems).to(contain(URLQueryItem(name: expandQueryName, value: TestExpandOption.all.rawValue)))
                        expect(request?.httpBody).toNot(beNil())
                        
                        guard let httpBody = request?.httpBody,
                            let bodyString = String(data: httpBody, encoding: .utf8) else {
                                fail("httpBody can't be nil")
                                return
                        }
                        for param in params {
                            expect(bodyString).to(contain(param.key))
                            expect(bodyString).to(contain(param.value))
                        }
                    }
                }
            }
        }
    }
    
    private static func components(from request: URLRequest?) -> URLComponents {
        guard let urlString = request?.url?.absoluteString,
            let components = URLComponents(string: urlString) else {
                fail("asURLRequest method works incorrectly")
                return URLComponents()
        }
        return components
    }
    
}

private enum ExpandOptionTestAPI: ResourceAPIProtocol {
    
    case noExpandOptions
    case fewExpandOptions(expandOptions: [TestExpandOption])
    case fewExpandOptionsWithParams(expandOptions: [TestExpandOption], params: [String: String])
    case allExpandOptions
    case allExpandOptionsPost(parameters: [String: String])
    
    var path: String {
        return "/enpoint"
    }
    
    var method: HTTPMethod {
        switch self {
        case .allExpandOptionsPost: return .post
        default: return .get
        }
    }
    
    var parameters: RequestParameters? {
        switch self {
        case .fewExpandOptionsWithParams(_, let params):
            return .get(params)
        case .allExpandOptionsPost(let params):
            return .body(params)
        default: return nil
        }
    }
    
    var authentication: AuthenticationType {
        return .token
    }
    
    public var expandOptions: [String] {
        switch self {
        case .fewExpandOptions(let params),
             .fewExpandOptionsWithParams(let params, _):
            return params.map { $0.rawValue }
        case .allExpandOptions,
             .allExpandOptionsPost:
            return [TestExpandOption.all.rawValue]
        default: return []
        }
    }
    
}

private enum TestExpandOption: String {
    case from
    case to
    case buy
    case sell
    case all
}

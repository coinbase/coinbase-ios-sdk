//
//  IntegrationSpecProtocol.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

@testable import CoinbaseSDK
import Quick
import Nimble
import OHHTTPStubs

protocol IntegrationSpecProtocol {
    
    func url(withPath path: String, query: [String: String]) -> URLRequestExpectation
    func request(ofMethod method: HTTPMethod) -> URLRequestExpectation
    func hasAuthorization() -> URLRequestExpectation
    func hasBody(parameters: [String: Any?]) -> URLRequestExpectation
    
}

extension IntegrationSpecProtocol {
    
    func url(withPath path: String, query: [String: String] = [:]) -> URLRequestExpectation {
        return { request in
            let components = URLComponents(url: request.url!, resolvingAgainstBaseURL: true)
            expect(components?.path).to(endWith(path))
            query.map({ (key, value) in
                URLQueryItem(name: key, value: value)
            }).forEach { queryItem in
                expect(components?.queryItems).to(contain(queryItem))
            }
        }
    }
    
    func request(ofMethod method: HTTPMethod) -> URLRequestExpectation {
        return { req in
            expect(req.httpMethod).to(equal(method.rawValue))
        }
    }
    
    func hasAuthorization() -> URLRequestExpectation {
        return { req in
            expect(req.value(forHTTPHeaderField: HeaderKeys.authorization)).notTo(beEmpty())
        }
    }
    
    func hasBody(parameters: [String: Any?]) -> URLRequestExpectation {
        return { req in
            guard let bodyData = req.ohhttpStubs_httpBody,
                let json = (try? JSONSerialization.jsonObject(with: bodyData, options: [])) as? [String: Any?] else {
                    fail("HTTPBody is invalid or empty")
                    return
            }
            expect(json).to(equalDictionary(parameters))
        }
    }
    
    func successfulEmptyResult() -> ResultExpectation<EmptyData> {
        return { result in
            expect(result).to(beSuccessful())
        }
    }
    
    func successfulResult<T>(ofType: T.Type) -> ResultExpectation<T> {
        return { result in
            expect(result).to(beSuccessful())
            expect(result.value).notTo(beNil())
        }
    }
    
    func successfulList<T>(ofType: T.Type) -> ResultExpectation<ResponseModel<[T]>> {
        return { result in
            expect(result).to(beSuccessful())
            expect(result.value).notTo(beNil())
            expect(result.value?.data).notTo(beEmpty())
            expect(result.value?.pagination).notTo(beNil())
        }
        
    }
    
}

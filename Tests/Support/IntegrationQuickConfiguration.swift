//
//  IntegrationQuickConfiguration.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs

class IntegrationQuickConfiguration: QuickConfiguration {
    
    override class func configure(_ configuration: Configuration) {
        configuration.beforeEach { metadata in
            guard IntegrationQuickConfiguration.isIntegrationSpec(metadata: metadata) else {
                return
            }
            OHHTTPStubs.onStubMissing { req in
                fail("Unexpected and unstubed request was fired for: \(req.httpMethod ?? "") \(req.url?.absoluteString ?? "")")
            }
        }
        configuration.afterEach { metadata in
            guard IntegrationQuickConfiguration.isIntegrationSpec(metadata: metadata) else {
                return
            }
            OHHTTPStubs.removeAllStubs()
            OHHTTPStubs.onStubActivation(nil)
            OHHTTPStubs.onStubMissing(nil)
            OHHTTPStubs.onStubRedirectResponse(nil)
        }
    }
    
    private static func isIntegrationSpec(metadata: Quick.ExampleMetadata) -> Bool {
        let filePath = metadata.example.callsite.file
        return filePath.contains("Integration")
    }
    
}

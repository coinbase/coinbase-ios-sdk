//
//  SafariControllerOpenerSpec.swift
//  CoinbaseTests
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

@testable import CoinbaseSDK
import Quick
import Nimble
import SafariServices

class MockedViewController: UIViewController {
    
    var presentedController: UIViewController?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentedController = viewControllerToPresent
        if let completion = completion {
            completion()
        }
    }
    
}

class SafariControllerOpenerSpec: QuickSpec {
    
    override func spec() {
        describe("SafariControllerOpener") {
            let url = URL(string: NetworkConstants.baseURL)!
            let viewController = MockedViewController()
            let opener = SafariControllerOpener(viewController: viewController)
            it("open Safari Controller") {
                opener.open(url, options: [:]) { _ in }
                expect(viewController).notTo(beNil())
                expect(viewController.presentedController).to(beAnInstanceOf(SFSafariViewController.self))
            }
        }
    }
    
}

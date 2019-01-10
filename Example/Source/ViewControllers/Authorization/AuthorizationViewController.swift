//
//  AuthorizationViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class AuthorizationViewController: UIViewController {
    
    private let coinbase = Coinbase.default
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coinbase.oauth.configure(clientID: OAuth2ApplicationKeys.clientID,
                                 clientSecret: OAuth2ApplicationKeys.clientSecret,
                                 redirectURI: OAuth2ApplicationKeys.redirectURI,
                                 deeplinkURI: OAuth2ApplicationKeys.deeplinkURI)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !OAuth2ApplicationKeys.isConfigured {
            presentConfigurationAlert()
        }
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func signInAction() {
        authorize()
    }
    
    @IBAction func createAnAccountAction() {
        authorize(isSignup: true)
    }
    
    // MARK: - Private Methods
    
    private func authorize(isSignup: Bool = false) {
        guard OAuth2ApplicationKeys.isConfigured else {
            presentConfigurationAlert()
            return
        }
        do {
            try coinbase.oauth.beginAuthorization(layout: isSignup ? Layout.signup : nil,
                                                  scope: [Scope.Wallet.User.read,
                                                          Scope.Wallet.User.email,
                                                          Scope.Wallet.Accounts.read,
                                                          Scope.Wallet.Transactions.read,
                                                          Scope.Wallet.PaymentMethods.read],
                                                  account: .all,
                                                  meta: [Meta.SendLimit.amount: "1",
                                                         Meta.SendLimit.currency: "USD",
                                                         Meta.SendLimit.period: "day"],
                                                  flowType: .inApp(from: self))
        } catch OAuthError.notRegisteredSchemes(let schemes) {
            presentSchemeAlert(schemes: schemes)
        } catch let error {
            present(error: error)
        }
    }

}

private extension AuthorizationViewController {
    
    private func presentConfigurationAlert() {
        let alertMessage = "Please, provided OAuth2 Application Keys in Constants.swift file."
        let title = "Configuration is Missing"
        let logMessage = """
        \(title):
        \(alertMessage)
        For more details see https://github.com/coinbase/coinbase-ios-sdk#sample_app
        """
        print(logMessage)
        presentSimpleAlert(title: title, message: alertMessage)
    }
    
    private func presentSchemeAlert(schemes: Set<String>) {
        let alertMessage = "Please, add custom scheme used in your redirectURI in your Info.plist."
        let title = "URL scheme is not registered"
        let schemesString = "\"\(schemes.joined(separator: "\", \""))\""
        let logMessage = """
        \(title):
        \(schemesString) are not registered as a URL scheme. Please, add it in your Info.plist.
        For more details see https://github.com/coinbase/coinbase-ios-sdk#sample_app
        """
        print(logMessage)
        presentSimpleAlert(title: title, message: alertMessage)
    }
    
}

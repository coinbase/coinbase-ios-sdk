//
//  MenuViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class MenuViewController: UIViewController {
    
    private static let kErrorAlertTitle = "Something went wrong."
    private static let kSuccessAlertTitle = "Success!"
    
    private static let kEmptyTokenAlertMessage = "Unable to refresh access token. Refresh token is empty."
    
    private static let kRevokeAlertTitle = "Revoke Token."
    private static let kRevokeAlertMessage = "Are you sure you want to revoke token? This will automatically log you out."
    private static let kRevokeAlertActionTitle = "Revoke"
    private static let kRevokeAlertCancelTitle = "Cancel"
    
    private static let kRevokeSuccessAlertMessage = "Token was successfully revoked."
    
    private let coinbase = Coinbase.default

    // MARK: - IBAction Methods
    
    @IBAction func logOutAction(_ sender: UIBarButtonItem) {
        RootControllerCoordinator.setRoot(.authorization)
        
        guard let accessToken = TokenUtils.loadAccessToken() else {
            return
        }
        coinbase.tokenResource.revoke(accessToken: accessToken) { _ in }
    }
    
    @IBAction func refreshTokenAction() {
        guard let refreshToken = TokenUtils.loadRefreshToken() else {
            presentSimpleAlert(title: MenuViewController.kErrorAlertTitle,
                               message: MenuViewController.kEmptyTokenAlertMessage)
            return
        }
        coinbase.tokenResource.refresh(clientID: OAuth2ApplicationKeys.clientID,
                                       clientSecret: OAuth2ApplicationKeys.clientSecret,
                                       refreshToken: refreshToken) { [weak self] result in
                                        switch result {
                                        case .success(let userToken):
                                            let message = self?.tokenInfoMessage(from: userToken)
                                            self?.presentSimpleAlert(title: MenuViewController.kSuccessAlertTitle,
                                                                     message: message)
                                        case .failure(let error):
                                            self?.present(error: error)
                                        }
        }
    }
    
    @IBAction func revokeTokenAction() {
        let alertController = UIAlertController(title: MenuViewController.kRevokeAlertTitle,
                                                message: MenuViewController.kRevokeAlertMessage,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: MenuViewController.kRevokeAlertActionTitle, style: .destructive) { [weak self] _ in
            self?.revokeToken()
        })
        alertController.addAction(UIAlertAction(title: MenuViewController.kRevokeAlertCancelTitle, style: .cancel))
        present(alertController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func tokenInfoMessage(from userToken: UserToken) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        let date = Date(timeInterval: Double(userToken.expiresIn), since: Date())
        
        return "Token was successfully refreshed.\nNew access token will expire on:\n\n\(formatter.string(from: date))"
    }
    
    private func revokeToken() {
        guard let accessToken = TokenUtils.loadAccessToken() else {
            return
        }
        coinbase.tokenResource.revoke(accessToken: accessToken, completion: { [weak self] result in
            switch result {
            case .success:
                RootControllerCoordinator.rootViewController?
                    .presentSimpleAlert(title: MenuViewController.kSuccessAlertTitle,
                                        message: MenuViewController.kRevokeSuccessAlertMessage)
            case .failure(let error):
                self?.present(error: error)
            }
        })
    }
    
}

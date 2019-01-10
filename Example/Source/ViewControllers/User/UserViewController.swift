//
//  UserViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class UserViewController: UIViewController {
    
    @IBOutlet weak var userHeaderView: UserHeaderView!
    @IBOutlet weak var userDetailsView: UserDetailsStackView!
    @IBOutlet weak var authorizationInfoView: AuthorizationInfoStackView!
    
    private let coinbase = Coinbase.default
    private weak var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDetailsView.isHidden = true
        authorizationInfoView.isHidden = true
        
        activityIndicator = view.addCenteredActivityIndicator()
        
        loadUserDetails()
        loadAuthorizationInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Clear shadow image.
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Restore system shadow image.
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Private Methods
    
    private func loadUserDetails() {
        coinbase.userResource.current { [weak self] result in
            switch result {
            case .success(let user):
                self?.userHeaderView.setup(with: user)
                self?.userDetailsView.setup(with: user)
                self?.userDetailsView.isHidden = false
                self?.activityIndicator?.removeFromSuperview()
            case .failure(let error):
                self?.present(error: error)
            }
        }
    }
    
    private func loadAuthorizationInfo() {
        coinbase.userResource.authorizationInfo { [weak self] result in
            switch result {
            case .success(let info):
                self?.authorizationInfoView.setup(with: info)
                self?.authorizationInfoView.isHidden = false
                self?.activityIndicator?.removeFromSuperview()
            case .failure(let error):
                self?.present(error: error)
            }
        }
    }
    
}

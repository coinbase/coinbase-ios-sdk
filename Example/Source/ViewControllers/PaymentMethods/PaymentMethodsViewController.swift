//
//  PaymentMethodsViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class PaymentMethodsViewController: UIViewController {

    private static let kPaymentMethodCellID = "PaymentMethodCell"
    private static let kNoContentMessage = "You have no payment methods"

    @IBOutlet weak var tableView: UITableView!

    private let coinbase = Coinbase.default
    private let refreshControl = ThemeRefreshControll()
    private weak var activityIndicator: UIActivityIndicatorView?
    private var paymentMethods: [PaymentMethod] = []
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        setupTableView()
        activityIndicator = view.addCenteredActivityIndicator()
        loadPaymentMethods()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        refreshControl.addTarget(self, action: #selector(pullToRefreshViewShouldRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func pullToRefreshViewShouldRefresh() {
        loadPaymentMethods()
    }

    private func loadPaymentMethods() {
        coinbase.paymentMethodResource.list { [weak self] result in
            switch result {
            case .success(let responseModel):
                self?.update(with: responseModel.data)
            case .failure(let error):
                self?.present(error: error)
            }
            self?.activityIndicator?.removeFromSuperview()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func update(with paymentMethods: [PaymentMethod]) {
        self.paymentMethods = paymentMethods
        tableView.showBackgroundView(emptyMessage: PaymentMethodsViewController.kNoContentMessage,
                                     if: paymentMethods.isEmpty)
        tableView.reloadData()
    }

}

extension PaymentMethodsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PaymentMethodsViewController.kPaymentMethodCellID,
                                                 for: indexPath) as! PaymentMethodTableViewCell
        
        cell.setup(with: paymentMethods[indexPath.row])
        
        return cell
    }
    
}

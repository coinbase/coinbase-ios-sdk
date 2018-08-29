//
//  AccountsViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class AccountsViewController: UIViewController {

    private static let kAccountCellID = "accountCell"
    private static let kNoContentMessage = "You have no accounts"
    private static let kTransactionsSegueIdentifier = "showTransactions"

    @IBOutlet weak var tableView: UITableView!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    
    private let coinbase = Coinbase.default
    private let refreshControl = ThemeRefreshControll()
    private var accounts: [Account] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        activityIndicator = view.addCenteredActivityIndicator()
        loadAccounts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case AccountsViewController.kTransactionsSegueIdentifier:
            let transactionsViewController = segue.destination as! TransactionsViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            let account = accounts[indexPath.row]
            
            transactionsViewController.setup(with: account)
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        
        refreshControl.addTarget(self, action: #selector(pullToRefreshViewShouldRefresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func pullToRefreshViewShouldRefresh() {
        loadAccounts()
    }
    
    private func loadAccounts() {
        coinbase.accountResource.list { [weak self] result in
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
    
    private func update(with accounts: [Account]) {
        self.accounts = accounts
        tableView.showBackgroundView(emptyMessage: AccountsViewController.kNoContentMessage,
                                     if: accounts.isEmpty)
        tableView.reloadData()
    }
    
}

extension AccountsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AccountsViewController.kAccountCellID,
                                                 for: indexPath) as! AccountTableViewCell
        cell.setup(with: accounts[indexPath.row])
        
        return cell
    }
    
}

extension AccountsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

//
//  TransactionsViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class TransactionsViewController: UIViewController {
    
    private static let kDefaultTitle = "Transactions"
    private static let kNoContentMessage = "You have no transactions"
    private static let kTransactionCellID = "transactionCell"
    private static let kItemsPerPage = 3
    
    @IBOutlet weak var tableView: UITableView!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    private let coinbase = Coinbase.default
    private let refreshControl = ThemeRefreshControll()
    private var transactions: [Transaction] = []
    private var account: Account!
    private var paginationParameters: PaginationParameters?
    private var isLoading = false
    private let paginationActivityIndicator = UIActivityIndicatorView(style: .white)
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        activityIndicator = view.addCenteredActivityIndicator()
        loadTransactions()
    }
    
    // MARK: - Public Methods
    
    public func setup(with account: Account) {
        self.account = account
        title = account.name ?? TransactionsViewController.kDefaultTitle
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        paginationActivityIndicator.color = Colors.darkGray
        tableView.tableFooterView = UIView()
        
        refreshControl.addTarget(self, action: #selector(loadTransactions), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func setDefaults() {
        tableView.tableFooterView = UIView()
        transactions = []
        tableView.reloadData()
        paginationParameters = PaginationParameters(limit: TransactionsViewController.kItemsPerPage)
    }
    
    @objc private func loadTransactions() {
        setDefaults()
        loadNextPage()
    }
    
    private func loadNextPage() {
        guard let paginationParameters = paginationParameters, !isLoading else {
            return
        }
        isLoading = true
        coinbase.transactionResource.list(accountID: account.id, page: paginationParameters) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let responseModel):
                guard let isSamePage = self?.samePage(as: responseModel.pagination), isSamePage else {
                    self?.loadNextPage()
                    return
                }
                self?.paginationParameters = responseModel.pagination?.nextPage
                self?.update(with: responseModel.data)
            case .failure(let error):
                self?.present(error: error)
            }
            self?.activityIndicator?.removeFromSuperview()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func update(with loadedTransactions: [Transaction]) {
        transactions.append(contentsOf: loadedTransactions)
        tableView.showBackgroundView(emptyMessage: TransactionsViewController.kNoContentMessage,
                                     if: transactions.isEmpty)
        
        let indexes = loadedTransactions.compactMap { transaction in
            transactions
                .index { $0 === transaction }
                .map { IndexPath(row: $0, section: 0) }
        }
        
        tableView.insertRows(at: indexes, with: .automatic) { [weak self] in
            self?.tableView.showFooterView(with: self?.paginationActivityIndicator,
                                           if: self?.paginationParameters != nil)
        }
    }
    
    private func samePage(as pagination: Pagination?) -> Bool {
        var currentStartingAfterID: String?
        if case .some(.startingAfter(id: let startingAfterID)) = paginationParameters?.cursor {
            currentStartingAfterID = startingAfterID
        }
        return currentStartingAfterID == pagination?.startingAfter
    }
    
}

extension TransactionsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionsViewController.kTransactionCellID,
                                                 for: indexPath) as! TransactionTableViewCell
        
        cell.setup(with: transactions[indexPath.row])
        if indexPath.row == transactions.count - 1 {
            self.loadNextPage()
        }
        
        cell.tintColor = UIColor(hex: account?.currency?.color)
        
        return cell
    }
    
}

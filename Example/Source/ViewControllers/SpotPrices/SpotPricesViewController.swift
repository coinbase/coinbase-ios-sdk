//
//  SpotPricesViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class SpotPricesViewController: UIViewController {
    
    private static let kSpotPriceCellID = "spotPriceCell"
    
    public var selectedCurrency: String = Locale.current.currencyCode ?? "USD"
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private weak var activityIndicator: UIActivityIndicatorView?
    private let coinbase = Coinbase.default
    private let refreshControl = ThemeRefreshControll()
    private var prices: [Price] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyLabel.text = selectedCurrency
        setupTableView()
        activityIndicator = view.addCenteredActivityIndicator()
        loadSpotPrices()
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
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
        
        refreshControl.addTarget(self, action: #selector(loadSpotPrices), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func loadSpotPrices() {
        coinbase.pricesResource.spotPrices(fiat: selectedCurrency) { [weak self] result in
            switch result {
            case .success(let prices):
                self?.update(with: prices)
            case .failure(let error):
                self?.present(error: error)
            }
            self?.activityIndicator?.removeFromSuperview()
            self?.refreshControl.endRefreshing()
        }
    }
    
    private func update(with prices: [Price]) {
        self.prices = prices
        
        tableView.reloadData()
    }
    
}

extension SpotPricesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpotPricesViewController.kSpotPriceCellID,
                                                 for: indexPath) as! SpotPricesTableViewCell
        
        cell.setup(with: prices[indexPath.row])
        
        return cell
    }
    
}

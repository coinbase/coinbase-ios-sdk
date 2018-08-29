//
//  CurrenciesViewController.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit
import CoinbaseSDK

class CurrenciesViewController: UIViewController {
    
    private static let kSpotPricesSegueIdentifier = "spotPrices"
    private static let kCurrencyCellID = "currencyCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private let coinbase = Coinbase.default
    private let searchController = UISearchController(searchResultsController: nil)
    private var currencies: [CurrencyInfo] = []
    
    private lazy var indexedDataSource: IndexedDataSource<CurrencyInfo> =
        IndexedDataSource(cellIdentifier: CurrenciesViewController.kCurrencyCellID,
                          groupingBy: { String($0.id.first ?? "#").uppercased() },
                          configuration: { (cell, currency) in
                            guard let cell = cell as? CurrencyTableViewCell else { return }
                            cell.setup(with: currency)
        })
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        setupTableView()
        setupSearch()
        let activityIndicator = view.addCenteredActivityIndicator()
        
        coinbase.currenciesResource.get { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.update(with: currencies)
            case .failure(let error):
                self?.present(error: error)
            }
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case CurrenciesViewController.kSpotPricesSegueIdentifier:
            let spotPricesViewController = segue.destination as! SpotPricesViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)!
            spotPricesViewController.selectedCurrency = indexedDataSource.item(at: indexPath)!.id
        default:
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.dataSource = self.indexedDataSource
        tableView.delegate = self
        tableView.separatorColor = Colors.lightGray
        tableView.tintColor = Colors.lightBlue
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currency"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.barStyle = .black
    }
    
    private func update(with currencies: [CurrencyInfo]) {
        self.currencies = currencies
        updateTableView()
    }

    private func updateTableView() {
        indexedDataSource.items = filterCurrencies(for: searchController.searchBar.text)
        tableView.reloadData()
    }
    
    private func filterCurrencies(for text: String?) -> [CurrencyInfo] {
        guard let searchText = text?.lowercased(), !searchText.isEmpty else {
            return currencies
        }
        return currencies.filter { currency in
            [currency.id, currency.name]
                .map { $0.lowercased() }
                .contains(where: { name in name.contains(searchText) })
        }
    }
    
}

// MARK: - UISearchResultsUpdating extension

extension CurrenciesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        updateTableView()
    }
    
}

// MARK: - UITableViewDelegate extension

extension CurrenciesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as? UITableViewHeaderFooterView
        header?.textLabel?.font = UIFont(name: Fonts.demiBold, size: 20)
        header?.textLabel?.textColor = Colors.darkGray
        header?.backgroundView?.backgroundColor = Colors.lightGray
    }
    
}

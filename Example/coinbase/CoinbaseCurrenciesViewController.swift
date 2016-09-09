//
//  CoinbaseCurrenciesViewController.swift
//  Example of unautheticated API usage and of APIs returning arrays
//

import UIKit

class CoinbaseCurrenciesViewController: UITableViewController {

    var currencies : [CoinbaseCurrency]?

    override func viewDidAppear(_ animated: Bool) {

        Coinbase.setRequestTimeoutInterval(NSNumber(value: 15 as Double))
        
        // Load currencies
        
        Coinbase().getSupportedCurrencies() { (response: [Any]?, error: Error?) in

            if let currencies = response as? [CoinbaseCurrency] {
                self.currencies = currencies
                self.tableView.reloadData()
            } else {
                let alertView = UIAlertView(title: "Error", message: error?.localizedDescription ?? "Unknown error.", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencies = self.currencies {
            return currencies.count
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency")

        let label = cell?.viewWithTag(1) as? UILabel

        let currency = self.currencies?[indexPath.row]

        label?.text = currency?.name;

        return cell!
    }
}

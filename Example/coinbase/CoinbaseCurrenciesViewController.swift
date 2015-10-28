//
//  CoinbaseCurrenciesViewController.swift
//  Example of unautheticated API usage and of APIs returning arrays
//

import UIKit

class CoinbaseCurrenciesViewController: UITableViewController {

    var currencies : [CoinbaseCurrency]?

    override func viewDidAppear(animated: Bool) {

        // Load currencies
        Coinbase().getSupportedCurrencies() { (response: Array?, error: NSError?) in

            if let currencies = response as? [CoinbaseCurrency] {
                self.currencies = currencies
                self.tableView.reloadData()
            } else {
                let alertView = UIAlertView(title: "Error", message: error?.localizedDescription ?? "Unknown error.", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let currencies = self.currencies {
            return currencies.count
        } else {
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("currency")

        let label = cell?.viewWithTag(1) as? UILabel

        let currency = self.currencies?[indexPath.row]

        label?.text = currency?.name;

        return cell!
    }
}

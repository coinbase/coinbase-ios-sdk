//
//  CoinbaseBuySellViewController.swift
//  coinbase
//
//  Created by Dai Hovey on 29/04/2015.
//  Copyright (c) 2015 Isaac Waller. All rights reserved.
//

import UIKit

class CoinbaseBuySellViewController: UIViewController {

    @IBOutlet var buyTotal: UILabel!
    @IBOutlet var sellTotal: UILabel!
    @IBOutlet var spotPrice: UILabel!

    override func viewDidLoad() {

        Coinbase().getBuyPrice { (btc: CoinbaseBalance?, fees: Array?, subtotal: CoinbaseBalance?, total: CoinbaseBalance?, error: NSError?) in

            if let error = error {
                let alertView = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            } else {
                self.buyTotal.text = "Buy price: \(total!.amount!) BTC"
            }
        }

        Coinbase().getSellPrice { (btc: CoinbaseBalance?, fees: Array?, subtotal: CoinbaseBalance?, total: CoinbaseBalance?, error: NSError?) in

            if let error = error {
                let alertView = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            } else {
                self.sellTotal.text = "Sell price: \(total!.amount) BTC"
            }
        }

        Coinbase().getSpotRate { (spotPrice: CoinbaseBalance?, error: NSError?) in

            if let error = error {
                let alertView = UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
            } else {
                self.spotPrice.text = "Spot price: \(spotPrice!.amount!) BTC"
            }
        }
    }
}

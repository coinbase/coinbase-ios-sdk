//
//  UIViewController+PresentAlert.swift
//  iOS Example
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func present(error: Error) {
        presentSimpleAlert(title: "Error", message: error.localizedDescription)
    }
    
    public func presentSimpleAlert(title: String?, message: String?, cancelButtonTitle: String = "OK") {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: cancelButtonTitle, style: .cancel))
        present(alertController, animated: true)
    }
    
}

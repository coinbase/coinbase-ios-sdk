//
//  UITableView+Helpers.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import UIKit

extension UITableView {
    
    // MARK: - BackgroundView
    
    public func showBackgroundView(emptyMessage message: String, if show: Bool = true) {
        var backgroundView: UIView?
        if show {
            let messageLabel = createMessageLabel()
            messageLabel.text = message
            backgroundView = messageLabel
        }
        guard self.backgroundView != backgroundView else {
            return
        }
        self.backgroundView = backgroundView
    }
    
    private func createMessageLabel() -> UILabel {
        let messageLabel = UILabel()
        messageLabel.textColor = Colors.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: Fonts.regular, size: 16)
        return messageLabel
    }
    
    // MARK: - FooterView

    public func showFooterView(with indicator: UIActivityIndicatorView?, if show: Bool = true) {
        guard let indicator = indicator else {
            return
        }
        var footerView: UIView?
        if show {
            guard indicator.superview == nil else {
                return
            }
            footerView = createFooter(with: indicator)
            indicator.startAnimating()
        } else {
            indicator.stopAnimating()
            footerView = UIView()
        }
        tableFooterView = footerView
    }
    
    private func createFooter(with indicator: UIActivityIndicatorView) -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.size.width, height: 55))
        footerView.backgroundColor = .clear
        footerView.addSubview(indicator)
        indicator.center = CGPoint(x: footerView.bounds.size.width / 2,
                                   y: footerView.bounds.size.height / 2)
        return footerView
    }
    
    // MARK: - Insert Rows with Completion

    public func insertRows(at indexes: [IndexPath], with animation: UITableView.RowAnimation, completion: @escaping () -> Void) {
        CATransaction.begin()
        beginUpdates()
        CATransaction.setCompletionBlock(completion)
        insertRows(at: indexes, with: .automatic)
        endUpdates()
        CATransaction.commit()
    }
    
}

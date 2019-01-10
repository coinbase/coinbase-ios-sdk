//
//  PaymentMethodExpandOption.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Expand options for [Payment Method Resource](https://developers.coinbase.com/api/v2#payment-methods)
///
/// - fiatAccount: Expands `fiatAccount` property.
/// - all: Expands all expandable properties.
///
/// **Online API Documentation**
///
/// [Payment Method Resource](https://developers.coinbase.com/api/v2#payment-methods),
/// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
///
public enum PaymentMethodExpandOption: String {
    /// Expands `fiatAccount` property.
    case fiatAccount = "fiat_account"
    /// Expands all expandable properties.
    case all
}

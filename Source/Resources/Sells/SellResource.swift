//
//  SellResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `SellResource` is a class which implements API methods for [Sell Resource](https://developers.coinbase.com/api/v2#sells).
///
/// Sell resource represents a sell of bitcoin, bitcoin cash, litecoin or ethereum using a payment
/// method (either a bank or a fiat account). Each committed sell also has an associated transaction.
///
/// - Important:
///     Sells can be started with `commit: false` which is useful when displaying the confirmation for a sell.
///     These sells will never complete and receive an associated transaction unless they are committed separately.
///
/// **Online API Documentation**
///
/// [Sells](https://developers.coinbase.com/api/v2#sells),
/// [List sells](https://developers.coinbase.com/api/v2#list-sells),
/// [Show a sell](https://developers.coinbase.com/api/v2#show-a-sell),
/// [Place sell order](https://developers.coinbase.com/api/v2#place-sell-order),
/// [Commit a sell](https://developers.coinbase.com/api/v2#commit-a-sell)
///
open class SellResource: BaseResource, TradeResourceProtocol {
    
    /// Model for [Sell Resource](https://developers.coinbase.com/api/v2#sell-resource).
    public typealias Model = Sell
    /// Parameters for [Place sell order](https://developers.coinbase.com/api/v2#place-sell-order) request.
    public typealias Parameters = BuySellParameters
    
    /// Trade Resource of type [Sells](https://developers.coinbase.com/api/v2#sells).
    public var type: TradeResourceType = .sells
    
}

//
//  BuyResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `BuyResource` is a class which implements API methods for [Buy Resource](https://developers.coinbase.com/api/v2#buys).
///
/// Buy resource represents a purchase of bitcoin, bitcoin cash, litecoin or ethereum using a payment
/// method (either a bank or a fiat account). Each committed buy also has an associated transaction.
///
/// - Important:
///     Buys can be started with `commit: false` which is useful when displaying the confirmation for a buy.
///     These buys will never complete and receive an associated transaction unless they are committed separately.
///
/// - Warning:
///     When using this endpoint, it is possible that coinbase system will not be able to process the buy as normal.
///     If this is the case, our system will return a `400` error with an `id` of `unknown_error`.
///
/// **Online API Documentation**
///
/// [Buys](https://developers.coinbase.com/api/v2#buys),
/// [List buys](https://developers.coinbase.com/api/v2#list-buys),
/// [Show a buy](https://developers.coinbase.com/api/v2#show-a-buy),
/// [Place buy order](https://developers.coinbase.com/api/v2#place-buy-order),
/// [Commit a buy](https://developers.coinbase.com/api/v2#commit-a-buy)
///
open class BuyResource: BaseResource, TradeResourceProtocol {
    
    /// Model for [Buy Resource](https://developers.coinbase.com/api/v2#buy-resource).
    public typealias Model = Buy
    /// Parameters for [Place buy order](https://developers.coinbase.com/api/v2#place-buy-order) request.
    public typealias Parameters = BuySellParameters
    
    /// Trade Resource of type [Buys](https://developers.coinbase.com/api/v2#buys).
    public var type: TradeResourceType = .buys
    
}

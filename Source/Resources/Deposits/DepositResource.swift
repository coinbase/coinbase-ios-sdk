//
//  DepositResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `DepositResource` is a class which implements API methods for [Deposit Resource](https://developers.coinbase.com/api/v2#deposits).
///
/// Deposit resource represents a deposit of funds using a payment method (e.g. a bank).
/// Each committed deposit also has an associated transaction.
///
/// - Important:
///     Deposits can be started with `commit: false` which is useful when displaying the confirmation for a deposit.
///     These deposits will never complete and receive an associated transaction unless they are committed separately.
///
/// **Online API Documentation**
///
/// [Deposits](https://developers.coinbase.com/api/v2#deposits),
/// [List deposits](https://developers.coinbase.com/api/v2#list-deposits),
/// [Show a deposit](https://developers.coinbase.com/api/v2#show-a-deposit),
/// [Deposit funds](https://developers.coinbase.com/api/v2#deposit-funds),
/// [Commit a deposit](https://developers.coinbase.com/api/v2#commit-a-deposit)
///
open class DepositResource: BaseResource, TradeResourceProtocol {
    
    /// Model for [Deposit Resource](https://developers.coinbase.com/api/v2#deposit-resource).
    public typealias Model = Deposit
    /// Parameters for [Deposit funds](https://developers.coinbase.com/api/v2#deposit-funds) request.
    public typealias Parameters = DepositWithdrawalParameters
    
    /// Trade Resource of type [Deposits](https://developers.coinbase.com/api/v2#deposits).
    public var type: TradeResourceType = .deposits
    
}

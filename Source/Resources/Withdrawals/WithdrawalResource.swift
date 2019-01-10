//
//  WithdrawalResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `WithdrawalResource` is a class which implements API methods for [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawals).
///
/// Withdrawal resource represents a withdrawal of funds using a payment method (e.g. a bank).
/// Each committed withdrawal also has a associated transaction.
///
/// - Important:
///     Withdrawal can be started with `commit: false` which is useful when displaying the confirmation for a withdrawal.
///     These withdrawals will never complete and receive an associated transaction unless they are committed separately.
///
/// **Online API Documentation**
///
/// [Withdrawals](https://developers.coinbase.com/api/v2#withdrawals),
/// [List withdrawals](https://developers.coinbase.com/api/v2#list-withdrawals),
/// [Show a withdrawal](https://developers.coinbase.com/api/v2#show-a-withdrawal),
/// [Withdraw funds](https://developers.coinbase.com/api/v2#withdraw-funds),
/// [Commit a withdrawal](https://developers.coinbase.com/api/v2#commit-a-withdrawal)
///
open class WithdrawalResource: BaseResource, TradeResourceProtocol {
    
    /// Model for [Withdrawal Resource](https://developers.coinbase.com/api/v2#withdrawal-resource).
    public typealias Model = Withdrawal
    /// Parameters for [Withdraw funds](https://developers.coinbase.com/api/v2#withdraw-funds) request.
    public typealias Parameters = DepositWithdrawalParameters
    
    /// Trade Resource of type [Withdrawals](https://developers.coinbase.com/api/v2#withdrawals).
    public var type: TradeResourceType = .withdrawals
    
}

//
//  DepositWithdrawalParameters.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Parameters passed with request to deposit/withdrawal funds.
///
open class DepositWithdrawalParameters: TradeParameters {
    
    /// The ID of the payment method that should be used for the deposit/withdrawal.
    ///
    /// Payment methods can be listed using the `PaymentMethodResource.list` method.
    public var paymentMethod: String
    
    /// Creates `DepositWithdrawalParameters` with passed parameters.
    ///
    /// - Parameters:
    ///   - amount: Deposit/Withdrawal amount.
    ///   - currency: Currency for the `amount`.
    ///   - paymentMethod: The ID of the payment method that should be used for the deposit/withdrawal.
    ///
    ///       Payment methods can be listed using the `PaymentMethodResource.list` method.
    ///
    ///   - commit: If set to `false`, this deposit/withdrawal will not be immediately completed.
    ///       Use the `commit` method to complete.
    ///
    ///     **Note**
    ///
    ///       If property is `nil` order will be placed with `commit: true`.
    ///
    public init(amount: String, currency: String, paymentMethod: String, commit: Bool? = nil) {
        self.paymentMethod = paymentMethod
        
        super.init(amount: amount, currency: currency, commit: commit)
    }
    
    // MARK: - DictionaryConvertible Methods
    
    override public var toDictionary: [String: Any] {
        var dictionary = super.toDictionary
        
        dictionary[ParameterKeys.paymentMethod] = paymentMethod
        
        return dictionary
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let paymentMethod = "payment_method"
    }
    
}

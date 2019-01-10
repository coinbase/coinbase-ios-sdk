//
//  BuyParameters.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// Parameters passed with request to place buy/sell order.
///
/// - Note:
///     There are two ways to define buy/sell amounts – you can use either the amount or the total parameter:
///
///     1. When supplying `amount`, you’ll get the amount of bitcoin, bitcoin cash, litecoin or ethereum defined.
///     With `amount` it’s recommended to use `"BTC"` or `"ETH"` as the `currency` value,
///     but you can always specify a fiat currency and and the amount will be converted to BTC or ETH respectively.
///
///     2. When supplying `total`, your payment method will be debited (in case of buy) or credited (in case of sell) the total amount
///     and you’ll get the amount in BTC or ETH after fees have been reduced from the total/subtotal.
///     With `total` it’s recommended to use the currency of the payment method as the `currency` parameter,
///     but you can always specify a different currency and it will be converted.
///
///     Given the price of digital currency depends on the time of the call and on the amount of purchase,
///     it’s recommended to use the `commit: false` parameter to create an uncommitted buy/sell
///     to show the confirmation for the user or get the final quote, and commit that with a separate request.
///
///     If you need to query the buy/sell price without locking in the buy/sell, you can use `quote: true` option.
///     This returns an unsaved `Buy`/`Sell` and unlike `commit: false`, this `Buy`/`Sell` can’t be completed.
///     This option is useful when you need to show the detailed buy/sell price
///     quote for the user when they are filling a form or similar situation.
///
open class BuySellParameters: TradeParameters {

    /// The ID of the payment method that should be used for the buy/sell.
    ///
    /// Payment methods can be listed using the `PaymentMethodResource.list` method.
    public var paymentMethod: String?
    /// Buy/Sell amount with fees (alternative to `amount`).
    public var total: String?
    /// Whether or not you would still like to buy/sell if you have to wait for your money to arrive to lock in a price.
    public var agreeBTCAmountVaries: Bool?
    /// If set to true, response will return an unsave buy/sell for detailed price quote.
    ///
    /// - Note:
    ///     If property is `nil` order will be placed with `quote: false`.
    ///
    /// - Important:
    ///     See `BuySellParameters` description for more information about how this parameter affect placing buy/sell order request.
    ///
    public var quote: Bool?
    
    /// Creates `BuySellParameters` with passed parameters.
    ///
    /// - Parameters:
    ///   - amount: Buy/sell amount.
    ///   - total: Buy/Sell amount with fees (alternative to `amount`).
    ///   - currency: Currency for the `amount`.
    ///   - paymentMethod: The ID of the payment method that should be used for the buy/sell.
    ///
    ///       Payment methods can be listed using the `PaymentMethodResource.list` method.
    ///
    ///   - agreeBTCAmountVaries: Whether or not you would still like to buy/sell if you have
    ///       to wait for your money to arrive to lock in a price.
    ///
    ///   - commit: If set to `false`, this buy/sell will not be immediately completed.
    ///         Use the `commit` method to complete.
    ///
    ///       **Note**
    ///
    ///       If property is `nil` order will be placed with `commit: true`.
    ///
    ///      See `BuySellParameters` description for more information how this parameter affect placing order request.
    ///
    ///   - quote: If set to true, response will return an unsave `Buy`/`Sell` for detailed price quote.
    ///
    ///       **Note**
    ///
    ///       If property is `nil` order will be placed with `quote: false`.
    ///
    ///     See `BuySellParameters` description for more information about how this parameter affect placing buy/sell order request.
    ///
    public init(amount: String, total: String? = nil, currency: String, paymentMethod: String? = nil,
                agreeBTCAmountVaries: Bool? = nil, commit: Bool? = nil, quote: Bool? = nil) {
        self.paymentMethod = paymentMethod
        self.total = total
        self.agreeBTCAmountVaries = agreeBTCAmountVaries
        self.quote = quote
        
        super.init(amount: amount, currency: currency, commit: commit)
    }
    
    // MARK: - DictionaryConvertible Methods
    
    override public var toDictionary: [String: Any] {
        var dictionary = super.toDictionary
        
        if let paymentMethod = paymentMethod {
            dictionary[ParameterKeys.paymentMethod] = paymentMethod
        }
        if let total = total {
            dictionary[ParameterKeys.total] = total
        }
        if let agreeBTCAmountVaries = agreeBTCAmountVaries {
            dictionary[ParameterKeys.agreeBTCAmountVaries] = String(agreeBTCAmountVaries)
        }
        if let quote = quote {
            dictionary[ParameterKeys.quote] = String(quote)
        }
        
        return dictionary
    }
    
    // MARK: - Parameter Constants
    
    private struct ParameterKeys {
        static let paymentMethod = "payment_method"
        static let total = "total"
        static let agreeBTCAmountVaries = "agree_btc_amount_varies"
        static let quote = "quote"
    }
    
}

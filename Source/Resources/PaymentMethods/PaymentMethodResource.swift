//
//  PaymentMethodResource.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

/// `PaymentMethodResource` is a class which implements API methods for
/// [Payment Method Resource](https://developers.coinbase.com/api/v2#payment-methods)
///
/// Payment method resource represents the different kinds of payment methods that can be
/// used when buying and selling bitcoin, bitcoin cash, litecoin or ethereum.
///
/// As fiat accounts can be used for buying and selling, they have an associated payment method.
/// This type of a payment method will also have a `fiatAccount` reference to the actual account.
///
/// If the user has obtained optional `Scope.Wallet.PaymentMethods.limits` permission, an additional field,
/// `limits`, will be embedded into payment method model. It will contain information about buy, instant buy,
/// sell and deposit limits (there’s no limits for withdrawals at this time). As each one of these can have
/// several limits you should always look for the lowest remaining value when performing the relevant action.
///
/// **Online API Documentation**
///
/// [Payment methods](https://developers.coinbase.com/api/v2#payment-methods)
///
open class PaymentMethodResource: BaseResource {
    
    /// Fetches a list of current user’s payment methods.
    ///
    /// - Parameters:
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// - Important:
    ///     If the user has obtained optional `Scope.Wallet.PaymentMethods.limits` permission, an additional field,
    ///     `limits`, will be embedded into payment method model. It will contain information about buy, instant buy,
    ///     sell and deposit limits (there’s no limits for withdrawals at this time). As each one of these can have
    ///     several limits you should always look for the lowest remaining value when performing the relevant action.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.PaymentMethods.read`
    ///
    /// **Online API Documentation**
    ///
    /// [List payment methods](https://developers.coinbase.com/api/v2#list-payment-methods),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources),
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    public func list(expandOptions: [PaymentMethodExpandOption] = [],
                     page: PaginationParameters = PaginationParameters(),
                     completion: @escaping (_ result: Result<ResponseModel<[PaymentMethod]>>) -> Void) {
        let endpoint = PaymentMethodsAPI.list(expandOptions: expandOptions, page: page)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Fetches an individual payment method by ID.
    ///
    /// - Parameters:
    ///   - id: ID of a payment method.
    ///   - expandOptions: An array of fields to expand.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// - Important:
    ///     If the user has obtained optional `Scope.Wallet.PaymentMethods.limits` permission, an additional field,
    ///     `limits`, will be embedded into payment method model. It will contain information about buy, instant buy,
    ///     sell and deposit limits (there’s no limits for withdrawals at this time). As each one of these can have
    ///     several limits you should always look for the lowest remaining value when performing the relevant action.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.PaymentMethods.read`
    ///
    /// **Online API Documentation**
    ///
    /// [Show a payment method](https://developers.coinbase.com/api/v2#show-a-payment-method),
    /// [Expand options](https://developers.coinbase.com/api/v2#expanding-resources)
    ///
    public func paymentMethod(id: String,
                              expandOptions: [PaymentMethodExpandOption] = [],
                              completion: @escaping (_ result: Result<PaymentMethod>) -> Void) {
        let endpoint = PaymentMethodsAPI.paymentMethod(id: id, expandOptions: expandOptions)
        performRequest(for: endpoint, completion: completion)
    }
    
    /// Removes payment method
    ///
    /// - Parameters:
    ///   - id: ID of a payment method.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.PaymentMethods.delete`
    ///
    public func deletePaymentMethod(id: String, completion: @escaping (_ result: Result<EmptyData>) -> Void) {
        let endpoint = PaymentMethodsAPI.deletePaymentMethod(id: id)
        performRequest(for: endpoint, completion: completion)
    }
    
}

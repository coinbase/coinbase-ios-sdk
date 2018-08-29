//
//  PaymentMethodResource+Rx.swift
//  CoinbaseRx
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 
import RxSwift
#if !COCOAPODS
import CoinbaseSDK
#endif

// MARK: - RxSwift extension for PaymentMethodResource

extension PaymentMethodResource {
    
    /// Fetches a list of current user’s payment methods.
    ///
    /// - Parameters:
    ///   - expandOptions: An array of fields to expand.
    ///   - page: Instance of `PaginationParameters` which defines size, cursor position and order of requested list.
    ///
    ///     If not provided, default value is used.
    ///
    /// - Returns: `Single` containing requested model.
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
    public func rx_list(expandOptions: [PaymentMethodExpandOption] = [], page: PaginationParameters = PaginationParameters()) -> Single<ResponseModel<[PaymentMethod]>> {
        return Single.create { single in
            self.list(expandOptions: expandOptions, page: page, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Fetches an individual payment method by ID.
    ///
    /// - Parameters:
    ///   - id: ID of a payment method.
    ///   - expandOptions: An array of fields to expand.
    ///
    /// - Returns: `Single` containing requested model.
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
    public func rx_paymentMethod(id: String, expandOptions: [PaymentMethodExpandOption] = []) -> Single<PaymentMethod> {
        return Single.create { single in
            self.paymentMethod(id: id, expandOptions: expandOptions, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
    /// Removes payment method
    ///
    /// - Parameters:
    ///   - id: ID of a payment method.
    ///   - completion: The completion handler to call when the request is complete.
    ///
    /// - Returns: `Single` containing requested model.
    ///
    /// **Required Scopes**
    ///
    /// - `Scope.Wallet.PaymentMethods.delete`
    ///
    public func rx_deletePaymentMethod(id: String) -> Single<EmptyData> {
        return Single.create { single in
            self.deletePaymentMethod(id: id, completion: SessionManager.completion(with: single))
            return Disposables.create()
        }
    }
    
}

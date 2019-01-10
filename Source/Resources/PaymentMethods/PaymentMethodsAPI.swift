//
//  PaymentMethodsApi.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `PaymentMethodsAPI` defines required parameters to create and validate all API requests
/// for [Payment Method Resource](https://developers.coinbase.com/api/v2#payment-methods)
///
/// - list: Represents [List payment methods](https://developers.coinbase.com/api/v2#list-payment-methods) API request.
/// - paymentMethod: Represents [Show a payment method](https://developers.coinbase.com/api/v2#show-a-payment-method) API request.
/// - deletePaymentMethod: Represents `Delete payment method` API request.
///
public enum PaymentMethodsAPI: ResourceAPIProtocol {
    
    /// Represents [List payment methods](https://developers.coinbase.com/api/v2#list-payment-methods) API request.
    case list(expandOptions: [PaymentMethodExpandOption], page: PaginationParameters)
    /// Represents [Show a payment method](https://developers.coinbase.com/api/v2#show-a-payment-method) API request.
    case paymentMethod(id: String, expandOptions: [PaymentMethodExpandOption])
    /// Represents `Delete payment method` API request.
    case deletePaymentMethod(id: String)
    
    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .list:
            return "/\(PathConstants.paymentMethods)"
        case .paymentMethod(let id, _),
             .deletePaymentMethod(let id):
            return "/\(PathConstants.paymentMethods)/\(id)"
        }        
    }
    
    public var method: HTTPMethod {
        switch self {
        case .list, .paymentMethod: return .get
        case .deletePaymentMethod: return .delete
        }
    }
    
    public var parameters: RequestParameters? {
        switch self {
        case .list(_, let page): return .get(page.parameters)
        default: return nil
        }
    }
    
    public var expandOptions: [String] {
        switch self {
        case .list(let expandOptions, _),
             .paymentMethod(_, let expandOptions):
            return expandOptions.rawValues
        case .deletePaymentMethod:
            return []
        }
    }
    
    public var authentication: AuthenticationType {
        return .token
    }
    
    public var allowEmptyResponse: Bool {
        switch self {
        case .deletePaymentMethod: return true
        default: return false
        }
    }
    
}

//
//  TransactionsAPI.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// `TransactionsAPI` defines required parameters to create and validate all API requests
/// for [Transaction Resource](https://developers.coinbase.com/api/v2#transactions).
///
/// - list: Represents [List transactions](https://developers.coinbase.com/api/v2#list-transactions) API request.
/// - transaction: Represents [Show a transaction](https://developers.coinbase.com/api/v2#show-a-transaction) API request.
/// - send: Represents [Send money](https://developers.coinbase.com/api/v2#send-money) API request.
/// - request: Represents [Request money](https://developers.coinbase.com/api/v2#request-money) API request.
/// - completeRequest: Represents [Complete request money](https://developers.coinbase.com/api/v2#complete-request-money) API request.
/// - resendRequest: Represents [Re-send request money](https://developers.coinbase.com/api/v2#re-send-request-money) API request.
/// - cancelRequest: Represents [Cancel request money](https://developers.coinbase.com/api/v2#cancel-request-money) API request.
///
public enum TransactionsAPI: ResourceAPIProtocol {
    
    /// Represents [List transactions](https://developers.coinbase.com/api/v2#list-transactions) API request.
    case list(accountID: String, expandOptions: [TransactionExpandOption], page: PaginationParameters)
    /// Represents [Show a transaction](https://developers.coinbase.com/api/v2#show-a-transaction) API request.
    case transaction(accountID: String, transactionID: String, expandOptions: [TransactionExpandOption])
    /// Represents [Send money](https://developers.coinbase.com/api/v2#send-money) API request.
    case send(accountID: String, twoFactorAuthToken: String?, expandOptions: [TransactionExpandOption], parameters: SendTransactionParameters)
    /// Represents [Request money](https://developers.coinbase.com/api/v2#request-money) API request.
    case request(accountID: String, expandOptions: [TransactionExpandOption], parameters: RequestTransactionParameters)
    /// Represents [Complete request money](https://developers.coinbase.com/api/v2#complete-request-money) API request.
    case completeRequest(accountID: String, transactionID: String, expandOptions: [TransactionExpandOption])
    /// Represents [Re-send request money](https://developers.coinbase.com/api/v2#re-send-request-money) API request.
    case resendRequest(accountID: String, transactionID: String, expandOptions: [TransactionExpandOption])
    /// Represents [Cancel request money](https://developers.coinbase.com/api/v2#cancel-request-money) API request.
    case cancelRequest(accountID: String, transactionID: String)
    
    // MARK: - ResourceAPIProtocol
    
    public var path: String {
        switch self {
        case .list(let accountID, _, _),
             .send(let accountID, _, _, _),
             .request(let accountID, _, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.transactions)"
        case .transaction(let accountID, let transactionID, _),
             .cancelRequest(let accountID, let transactionID):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.transactions)/\(transactionID)"
        case .completeRequest(let accountID, let transactionID, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.transactions)/\(transactionID)/\(PathConstants.complete)"
        case .resendRequest(let accountID, let transactionID, _):
            return "/\(PathConstants.accounts)/\(accountID)/\(PathConstants.transactions)/\(transactionID)/\(PathConstants.resend)"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .list,
             .transaction:
            return .get
        case .send,
             .request,
             .completeRequest,
             .resendRequest:
            return .post
        case .cancelRequest:
            return .delete
        }
    }
    
    public var parameters: RequestParameters? {
        switch self {
        case .transaction,
             .completeRequest,
             .resendRequest,
             .cancelRequest:
            return nil
        case .list(_, _, let page):
            return .get(page.parameters)
        case .send(_, _, _, let parameters):
            return .body(parameters.toDictionary)
        case .request(_, _, let parameters):
            return .body(parameters.toDictionary)
        }
    }
    
    public var headers: [String: String] {
        switch self {
        case .send(_, let .some(twoFactorAuthToken), _, _):
            return [HeaderKeys.cb2FA: twoFactorAuthToken]
        default:
            return [:]
        }
    }
    
    public var authentication: AuthenticationType {
        return .token
    }
    
    public var allowEmptyResponse: Bool {
        switch self {
        case .list,
             .transaction,
             .send,
             .request,
             .completeRequest,
             .resendRequest:
            return false
        case .cancelRequest:
            return true
        }
    }
    
    public var expandOptions: [String] {
        switch self {
        case .list(_, let expandOptions, _),
             .transaction(_, _, let expandOptions),
             .send(_, _, let expandOptions, _),
             .request(_, let expandOptions, _),
             .completeRequest(_, _, let expandOptions),
             .resendRequest(_, _, let expandOptions):
            return expandOptions.rawValues
        case .cancelRequest:
            return []
        }
    }
    
}

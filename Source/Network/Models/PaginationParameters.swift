//
//  PaginationParameters.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Availble sorting order options.
///
/// - asc: Ascending order.
/// - desc: Descending order.
///
public enum ListOrder: String, Decodable {
    /// Ascending order.
    case asc
    /// Descending order.
    case desc
}

/// Pagination parameters for requests supporting cursor based pagination.
///
/// - Note:
///     Can be created form `Pagination` object of `ResponseModel`.
///
/// **Online API Documentation**
///
/// [Pagination](https://developers.coinbase.com/api/v2#pagination)
///
open class PaginationParameters {
    
    /// A cursor position to use in pagination.
    ///
    /// - startingAfter: Cursor pointing to the item page will start after.
    /// - endingBefore: Cursor pointing to the item page will end before.
    ///
    public enum Cursor {
        /// Cursor pointing to the item page will start after.
        case startingAfter(id: String)
        /// Cursor pointing to the item page will end before.
        case endingBefore(id: String)
    }
    
    /// Cursor position.
    public var cursor: Cursor?
    
    /// Number of items per page.
    ///
    /// **Accepted values**: 0 - 100
    ///
    /// If no limit provided then default (25) value will be use.
    ///
    public var limit: Int?
    
    /// Items sort order.
    ///
    /// If no order specifyed then default (`desc`) order will be use.
    ///
    public var order: ListOrder?
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - limit: Number of items per page.
    ///
    ///       **Accepted values**: 0 - 100
    ///
    ///       If no limit provided then default (25) value will be use.
    ///
    ///   - order: Items sort order.
    ///
    ///       If no order specifyed then default (Descending) order will be use.
    ///
    ///   - cursor: Cursor position.
    ///
    public init(limit: Int? = nil, order: ListOrder? = nil, cursor: Cursor? = nil) {
        self.limit = limit
        self.order = order
        self.cursor = cursor
    }
    
    /// Creates a new instance from URI.
    ///
    /// - Parameter uri: URI.
    ///
    private init?(uri: String?) {
        guard let uri = uri else { return nil }
        let components = URLComponents(string: uri)
        components?.queryItems?.forEach {
            guard let value = $0.value else { return }
            switch $0.name {
            case ParametersKeys.limit: limit = Int(value)
            case ParametersKeys.endingBefore: cursor = .endingBefore(id: value)
            case ParametersKeys.startingAfter: cursor = .startingAfter(id: value)
            case ParametersKeys.order: order = ListOrder(rawValue: value)
            default: break
            }
        }
    }
    
    /// Converts to Dictionary.
    public var parameters: [String: String] {
        var dictinary: [String: String] = [:]
        if let limit = limit {
            dictinary[ParametersKeys.limit] = String(limit)
        }
        if let order = order {
            dictinary[ParametersKeys.order] = order.rawValue
        }
        switch cursor {
        case let .some(.endingBefore(id)):
            dictinary[ParametersKeys.endingBefore] = id
        case let .some(.startingAfter(id)):
            dictinary[ParametersKeys.startingAfter] = id
        default: break
        }
        return dictinary
    }
    
    private struct ParametersKeys {
        static let limit = "limit"
        static let endingBefore = "ending_before"
        static let startingAfter = "starting_after"
        static let order = "order"
    }
    
}

// MARK: - Create `PaginationParameters` from `Pagination`.

public extension PaginationParameters {
    
    /// Creates pagination parameters for next page request.
    public static func nextPage(from pagination: Pagination?) -> PaginationParameters? {
        return PaginationParameters(uri: pagination?.nextURI)
    }
    
    /// Creates pagination parameters for previous page request.
    public static func previousPage(from pagination: Pagination?) -> PaginationParameters? {
        return PaginationParameters(uri: pagination?.previousURI)
    }
    
}

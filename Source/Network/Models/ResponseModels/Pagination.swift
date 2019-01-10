//
//  Pagination.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents cursor based pagination data returned from server.
///
/// **Online API Documentation**
///
/// [Pagination](https://developers.coinbase.com/api/v2#pagination)
///
open class Pagination: Decodable {

    /// Cursor used in current request.
    ///
    /// It is a resource ID of the next item.
    ///
    /// Present if `endingBefore` pagination parameter was set for current request.
    ///
    public let endingBefore: String?
    
    /// Cursor used in current request.
    ///
    /// It is a resource ID of the previous item.
    ///
    /// Present if `startingAfter` pagination parameter was set for current request.
    ///
    public let startingAfter: String?
    
    /// Number of items per page.
    public let limit: Int
    /// Page items order.
    public let order: ListOrder
    /// URI for the previous page with updated cursor but with the same `limit` and `order` parameters as in the current request.
    ///
    /// `nil` if there is no previous page.
    public let previousURI: String?
    /// URI for the next page with updated cursor but with the same `limit` and `order` parameters as in the current request.
    ///
    /// `nil` if there is no next page.
    public let nextURI: String?

    private enum CodingKeys: String, CodingKey {
        case endingBefore, startingAfter, limit, order, previousURI = "previousUri", nextURI = "nextUri"
    }
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameters:
    ///   - endingBefore: Cursor used in pagination for request.
    ///   - startingAfter: Cursor used in pagination for request.
    ///   - limit: Number of items per page.
    ///   - order: Page items order.
    ///   - previousURI: URI for next page.
    ///   - nextURI: URI for previous page.
    ///
    internal init(endingBefore: String? = nil, startingAfter: String? = nil, limit: Int,
                  order: ListOrder, previousURI: String? = nil, nextURI: String? = nil) {
        self.endingBefore = endingBefore
        self.startingAfter = startingAfter
        self.limit = limit
        self.order = order
        self.previousURI = previousURI
        self.nextURI = nextURI
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        endingBefore = try values.decodeIfPresent(String.self, forKey: .endingBefore)
        startingAfter = try values.decodeIfPresent(String.self, forKey: .startingAfter)
        limit = try values.decode(Int.self, forKey: .limit)
        order = try values.decode(ListOrder.self, forKey: .order)
        previousURI = try values.decodeIfPresent(String.self, forKey: .previousURI)
        nextURI = try values.decodeIfPresent(String.self, forKey: .nextURI)
    }

}

// MARK: - Create `PaginationParameters`.

extension Pagination {
    
    /// Creates pagination parameters for next page request.
    public var nextPage: PaginationParameters? {
        return PaginationParameters.nextPage(from: self)
    }
    
    /// Creates pagination parameters for previous page request.
    public var previousPage: PaginationParameters? {
        return PaginationParameters.previousPage(from: self)
    }
    
}

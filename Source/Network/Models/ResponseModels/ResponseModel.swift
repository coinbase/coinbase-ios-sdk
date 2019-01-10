//
//  ResponseModel.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// The response object returned by server on successful request.
///
/// All `GET` endpoints which return an object list support cursor based pagination.
///
/// **Online API Documentation**
///
/// [Pagination](https://developers.coinbase.com/api/v2#pagination),
/// [Warnings](https://developers.coinbase.com/api/v2#warnings)
///
open class ResponseModel<T: Decodable>: Decodable, ConvertibleFromData {

    /// Decoded model from `data` response field.
    public let data: T
    
    /// Represents cursor based pagination model.
    ///
    /// Presented in all requests where response is an object list.
    ///
    /// **Online API Documentation**
    ///
    /// [Pagination](https://developers.coinbase.com/api/v2#pagination)
    ///
    public let pagination: Pagination?
    
    /// List of warnings to notify the developer of best practices,
    /// implementation suggestions or deprecation.
    ///
    /// While you don’t need show warnings to the user,
    /// they are usually something you need to act on.
    ///
    /// **Online API Documentation**
    ///
    /// [Warnings](https://developers.coinbase.com/api/v2#warnings)
    ///
    public let warnings: [Warning]?
    
    private enum CodingKeys: String, CodingKey {
        case data, pagination, warnings
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        data = try values.decode(T.self, forKey: .data)
        pagination = try values.decodeIfPresent(Pagination.self, forKey: .pagination)
        warnings = try values.decodeIfPresent([Warning].self, forKey: .warnings)
    }

}

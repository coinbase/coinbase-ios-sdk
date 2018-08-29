//
//  TimeResource.swift
//  Coinbase
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

/// `TimeResource` is a class which implements API methods for [Time](https://developers.coinbase.com/api/v2#time).
///
/// **Online API Documentation**
///
/// [Time](https://developers.coinbase.com/api/v2#time)
///
open class TimeResource: BaseResource {

    /// Fetches the API server time.
    ///
    /// - Parameters:
    ///   - completion: The completion handler to call when the request is complete.
    ///
    ///     Completion handler takes the following parameters:
    ///
    ///   - result: An enum case containing a parsed model if request was succeessful or an error otherwise.
    ///
    /// **Required Scopes**
    ///
    ///   - *No scope required*
    ///
    /// **Online API Documentation**
    ///
    ///  [Get current time](https://developers.coinbase.com/api/v2#get-current-time)
    ///
    public func get(completion: @escaping (_ result: Result<TimeInfo>) -> Void) {
        let endpoint = TimeAPI.get
        performRequest(for: endpoint, completion: completion)
    }
    
}

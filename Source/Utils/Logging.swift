//
//  Logging.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 
import Foundation

/// Logging message category.
///
/// - Important:
///      For **Release** Build Configuration only `LoggingCategory.error` can be enabled.
///
/// - info: Verbose information.
///
///     Available only in `Debug` Build Configuration.
///
/// - `warning`: Warning messages to notify the developer of best practices,
///         implementation suggestions or deprecation.
///
///     Available only in `Debug` Build Configuration.
///
/// - error: Error message.
///
///     Available in both `Debug` and `Release` Build Configurations.
///
public enum LoggingCategory: String {
    /// Verbose information.
    ///
    /// Available only in `Debug` Build Configuration.
    ///
    case info
    /// Warning messages to notify the developer of best practices,
    /// implementation suggestions or deprecation.
    ///
    /// Available only in `Debug` Build Configuration.
    ///
    case warning
    /// Error message.
    ///
    /// Available in both `Debug` and `Release` Build Configurations.
    ///
    case error
    
    internal var canBeEnabled: Bool {
        #if DEBUG
        return true
        #else
        return self == .error
        #endif
    }
    
}

/// Responsible for SDK's logging functionality.
public struct CoinbaseLogger {
    
    /// Set of enabled categories.
    ///
    /// - Note:
    ///     Default value depends on `Debug/Release` Build Configuration flag:
    ///     - For **Debug** configuration: it is `LoggingCategory.warning` and `LoggingCategory.error`.
    ///     - For **Release** configuration: it is `LoggingCategory.error`.
    ///
    public static var enabled: Set<LoggingCategory> = {
        #if DEBUG
        return [.warning, .error]
        #else
        return [.error]
        #endif
        }() {
        didSet {
            enabled = enabled.filter { category -> Bool in
                guard category.canBeEnabled else {
                    log("\(self) | Category \"LoggingCategory.\(category)\" wasn't enabled. This category is supported only in Debug Configuration.", category: .error)
                    return false
                }
                return true
            }
        }
    }
    
}

/// Logs message.
///
/// - Note:
///     Mesage will be printed only if provided logging category is enabled.
///
/// - Parameters:
///   - message: Message to print.
///   - category: Log category for message.
///
internal func log(_ message: String, category: LoggingCategory = LoggingCategory.info) {
    if CoinbaseLogger.enabled.contains(category) {
        let output = "\(NSDate()) CoinbaseSDK[\(category.rawValue)] \(message)"
        print(output)
    }
}

// MARK: - Extensions with log discription property

internal extension URLRequest {
    
    var logDiscription: String {
        return "\(httpMethod ?? "") \(url?.absoluteString ?? "")"
    }
    
}

internal extension ResourceAPIProtocol {
    
    var logDiscription: String {
        return "method: \"\(method.rawValue.uppercased())\" path: \"..\(path)\""
    }
    
    var nameDiscription: String {
        return "\(type(of: self)) \(String(describing: self))"
    }
    
}

internal extension Warning {
    
    func log(with api: ResourceAPIProtocol) -> String {
        let reference: String
        if let url = url {
            reference = ". More info can be found at: \"\(url)\""
        } else {
            reference = ""
        }
        return "Server Warning | \(api.logDiscription) | id: \"\(id)\", message: \"\(message)\"\(reference)"
    }
    
}

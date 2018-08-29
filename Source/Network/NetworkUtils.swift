//
//  NetworkUtils.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Utils for Network layer.
internal struct NetworkUtils {

    /// A dictionary with required headers that will be part of each Request.
    /// These headers have superior priority over headers provided with Request.
    ///
    static var defaultHTTPHeaders: [String: Any] {

        var headers: [String: String] = [:]

        headers[HeaderKeys.userAgent] = userAgent
        headers[HeaderKeys.acceptEncoding] = "gzip;q=1.0, compress;q=0.5"
        headers[HeaderKeys.contentType] = "application/json"
        headers[HeaderKeys.accept] = "application/json"

        if let languageCode = NSLocale.current.languageCode {
            headers[HeaderKeys.acceptLanguage] = languageCode
        }

        headers[HeaderKeys.cbVersion] = NetworkConstants.clientVersion
        if let clientHeader = clientHeader() {
            headers[HeaderKeys.cbClient] = clientHeader
        }

        let currentDevice = GeneralDeviceInfo()
        headers[HeaderKeys.xIDFV] = currentDevice.uuid
        
        headers[HeaderKeys.xDeviceModel] = currentDevice.model
        headers[HeaderKeys.xDeviceBrand] = currentDevice.deviceManufacturer
        headers[HeaderKeys.xDeviceManufacturer] = currentDevice.deviceManufacturer
        headers[HeaderKeys.xDeviceName] = currentDevice.name
        
        headers[HeaderKeys.xOSName] = currentDevice.systemName
        headers[HeaderKeys.xOSVersion] = currentDevice.systemVersion

        headers[HeaderKeys.xAppBundleID] = Bundle.main.bundleIdentifier ?? ""
        headers[HeaderKeys.xAppName] = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String ?? ""
        headers[HeaderKeys.xAppVersion] = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        headers[HeaderKeys.xAppBuildNumber] = (Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String) ?? ""

        return headers
    }

    /// User Agent formatted string to provide with `"User-Agent"` header.
    static var userAgent: String {
        guard let info = Bundle.main.infoDictionary else {
            return "Coinbase"
        }

        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"

        let currentDevice = GeneralDeviceInfo()
        let osNameVersion = "\(currentDevice.systemName) \(currentDevice.systemVersion)"

        let coinbaseVersion: String = {
            guard let info = Bundle(for: SessionManager.self).infoDictionary,
                let build = info["CFBundleShortVersionString"] else {
                    return "Unknown"
            }

            return "Coinbase/\(build)"
        }()

        return "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(coinbaseVersion)"
    }

    /// Gets information about SDK client project.
    ///
    /// - Returns: Formatted string with SDK client information.
    ///
    static func clientHeader() -> String? {
        let mainBundle = Bundle.main
        var result: String?
        if let bundleIdentifier = mainBundle.bundleIdentifier,
            let appVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let appBuildVersionString = mainBundle.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            result = bundleIdentifier + "/" + appVersionString + "/" + appBuildVersionString
        }
        return result
    }

}

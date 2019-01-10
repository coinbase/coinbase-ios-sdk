//
//  GeneralDeviceInfo.swift
//  Coinbase
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

import Foundation

/// Gathers device information for `iOS` or other platforms.
///
internal class GeneralDeviceInfo {
    #if os(iOS)
    
    lazy var uuid: String? = UIDevice.current.identifierForVendor?.uuidString
    lazy var model: String = UIDevice.current.model
    lazy var name: String = UIDevice.current.name
    
    #else
    
    lazy var uuid: String? = {
        var hwUUIDBytes: [UInt8] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        var timeSpec = timespec(tv_sec: 0, tv_nsec: 0)
        gethostuuid(&hwUUIDBytes, &timeSpec)
        return NSUUID(uuidBytes: hwUUIDBytes).uuidString
    }()
    
    lazy var model: String = {
        var len: Int = 0
        sysctlbyname("hw.model", nil, &len, nil, 0)
        if len > 0 {
            let pointer = UnsafeMutablePointer<Int8>.allocate(capacity: len)
            sysctlbyname("hw.model", pointer, &len, nil, 0)
            return String(cString: pointer)
        }
        return ""
    }()
    
    lazy var name: String = Host.current().name ?? ""
    
    #endif
    
    lazy var systemName: String = {
        #if os(iOS)
        return "iOS"
        #elseif os(watchOS)
        return "watchOS"
        #elseif os(tvOS)
        return "tvOS"
        #elseif os(macOS)
        return "OS X"
        #elseif os(Linux)
        return "Linux"
        #else
        return "Unknown"
        #endif
    }()
    
    lazy var systemVersion: String = {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }()
    
    lazy var deviceManufacturer: String = {
        #if os(iOS) || os(watchOS) || os(tvOS) || os(macOS)
        return "Apple"
        #else
        return "Unknown"
        #endif
    }()
    
}

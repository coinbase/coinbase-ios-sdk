//
//  KeychainService.swift
//  iOS Example
//  
//  Copyright © 2018 Coinbase All rights reserved.
// 

import Foundation
import Security

private let tag = "com.coinbase.sdk.ios".data(using: .utf8)!

struct KeychainService {
    
    static func save(string: String?, for key: String) {
        // Delete storred string for key before storing new.
        deleteString(for: key)
        
        guard let stringData = string?.data(using: .utf8) else {
            return
        }
        
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                       kSecAttrService: tag,
                                       kSecAttrAccount: key,
                                       kSecValueData: stringData]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status != errSecSuccess {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("\(#function) Save failed: \(err)")
                }
            }
        }
    }
    
    static func loadString(for key: String) -> String? {
        let getquery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                         kSecAttrService: tag,
                                         kSecAttrAccount: key,
                                         kSecReturnData: kCFBooleanTrue,
                                         kSecMatchLimit: kSecMatchLimitOne]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("\(#function) Load failed: \(err)")
                }
            }
            return nil
        }
        guard let keyData = item as? Data else {
            return nil
        }
        return String(data: keyData, encoding: .utf8)
    }
    
    static func deleteString(for key: String) {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                       kSecAttrService: tag,
                                       kSecAttrAccount: key]
        let status = SecItemDelete(query as CFDictionary)
        
        if status != errSecSuccess && status != errSecItemNotFound {
            if #available(iOS 11.3, *) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("\(#function) Delete failed: \(err)")
                }
            }
        }
    }
    
}

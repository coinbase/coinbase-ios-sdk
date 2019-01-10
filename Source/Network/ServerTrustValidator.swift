//
//  ServerTrustPolicy.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//
import Security
import Foundation

// Based on https://github.com/Alamofire/Alamofire/blob/2fb881a1702cb1976c36192aceb54dcedab6fdc2/Source/ServerTrustPolicy.swift#L115

// MARK: - ServerTrustPolicy

/// The `ServerTrustValidator` evaluates the server trust generally provided by an `URLAuthenticationChallenge` when
/// connecting to a server over a secure HTTPS connection. The Validator determines whether the server trust is valid
/// and the connection should be made.
///
/// - Note:
///     Using pinned certificates or public keys for evaluation helps prevent man-in-the-middle (MITM) attacks and other
///     vulnerabilities. Applications dealing with sensitive customer data or financial information are strongly encouraged
///     to route all communication over an HTTPS connection with pinning enabled.
///
/// - Important:
///     Current implementation uses the pinned certificates to validate the server trust. The server trust is
///     considered valid if one of the pinned certificates match one of the server certificates.
///     By validating both the certificate chain and host, certificate pinning provides a very
///     secure form of server trust validation mitigating most, if not all, MITM attacks.
///
internal struct ServerTrustValidator {
    
    private let pinnedCertificates: [SecCertificate]
    
    /// Creates a new instance from given parameters.
    ///
    /// - Parameter pinnedCertificates: An array of trusted certificates.
    ///
    internal init(pinnedCertificates: [SecCertificate]) {
        self.pinnedCertificates = pinnedCertificates
    }
    
    // MARK: - Bundle Location
    
    /// Returns all certificates within the given bundle.
    ///
    /// - Note:
    ///     Current implementation supports next certificate extensions:
    ///
    ///     `.cer`, `.CER`, `.crt`, `.CRT`, `.der`, `.DER`
    ///
    /// - Parameters:
    ///     - bundle: The bundle to search for all certificate files.
    ///
    /// - Returns:
    ///     All certificates within the given bundle.
    ///
    internal static func certificates(in bundle: Bundle) -> [SecCertificate] {
        let certificateExtentions = [".cer", ".CER", ".crt", ".CRT", ".der", ".DER"]
        
        let paths = certificateExtentions.map { fileExtension in
            bundle.paths(forResourcesOfType: fileExtension, inDirectory: nil)
        }.joined()
        
        return Set(paths).compactMap { path in
            guard let certificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) as CFData,
                let certificate = SecCertificateCreateWithData(nil, certificateData) else {
                    return nil
            }
            return certificate
        }
    }

    // MARK: - Evaluation
    
    /// Evaluates whether the server trust is valid for the given host.
    ///
    /// - Parameters:
    ///     - serverTrust: The server trust to evaluate.
    ///     - host: The host of the challenge protection space.
    ///
    /// - Returns:
    ///     Whether the server trust is valid.
    ///
    internal func evaluate(_ serverTrust: SecTrust, forHost host: String) -> Bool {
        let policy = SecPolicyCreateSSL(true, host as CFString)
        SecTrustSetPolicies(serverTrust, policy)
        
        SecTrustSetAnchorCertificates(serverTrust, pinnedCertificates as CFArray)
        SecTrustSetAnchorCertificatesOnly(serverTrust, true)
        
        return trustIsValid(serverTrust)
    }
    
    // MARK: - Private - Trust Validation
    
    private func trustIsValid(_ trust: SecTrust) -> Bool {
        var result = SecTrustResultType.invalid
        let status = SecTrustEvaluate(trust, &result)
        return status == errSecSuccess && (result == .unspecified || result == .proceed)
    }

}

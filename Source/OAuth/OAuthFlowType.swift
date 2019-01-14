//
//  OAuthFlowType.swift
//  CoinbaseSDK
//  
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
// 

#if os(iOS)

import Foundation
import SafariServices

/// Defines available types of OAuth flow.
///
/// To authorize access to your application the SDK should redirect a user to Coinbase.
/// The SDK provides a few authorization flows.
///
/// - Note:
///     If you specified a special verifications deeplink as part of your OAuth application’s *advanced settings*
///     it is recommended to use `.inApp` flow for better user experience. Otherwise, you should take care of redirection flow.
///
/// - inApp: Performs authorization flow whithout leaving your application.
///
///     Current flow is based on `SFSafariViewController` and requires asociated `from` parameter to present
///     authorization controller from.
///
///   **Note:**
///     This flow type is recommended if you want to use verification deeplink to achieve a seamless transition.
///
/// - inSafari: Authorization flow redirects user to Safari.
///
///   **Note:**
///      This option does not support verification deeplink functionality.
///
/// - with: Custom authorization flow.
///
///     You can provide your own authorization flow with custom implementation of `URLOpenerProtocol`.
///
/// **Online API Documentation**
///
/// [Verification deeplink](https://developers.coinbase.com/docs/wallet/coinbase-connect/mobile#verification-deeplink)
///
public enum OAuthFlowType {
    /// Performs authorization flow whithout leaving your application.
    ///
    /// Current flow is based on `SFSafariViewController` and requires asociated `from` parameter to present
    /// authorization controller from.
    ///
    /// - Note:
    ///     This flow type is recommended if you want to use verification deeplink to achieve a seamless transition.
    ///
    case inApp(from: UIViewController)
    /// Authorization flow redirects user to Safari.
    ///
    /// **Note:**
    ///     This option does not support verification deeplink functionality.
    ///
    case inSafari
    /// Custom authorization flow.
    ///
    /// You can provide your own authorization flow with custom implementation of `URLOpenerProtocol`.
    ///
    case with(opener: URLOpenerProtocol)
    
    internal var opener: URLOpenerProtocol {
        switch self {
        case .inApp(let controller): return SafariControllerOpener(viewController: controller)
        case .inSafari: return UIApplication.shared
        case .with(let opener): return opener
        }
    }
    
}

/// Implementation for `URLOpenerProtocol` that uses `SFSafariViewController` to open URLs.
internal struct SafariControllerOpener: URLOpenerProtocol {
    
    weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func canOpenURL(_ url: URL) -> Bool {
        return UIApplication.shared.canOpenURL(url)
    }
    
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?) {
        let safariController = SFSafariViewController(url: url)
        viewController?.present(safariController, animated: true) {
            completion?(true)
        }
    }
    
}

#endif

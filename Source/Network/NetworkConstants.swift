//
//  NetworkConstants.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase. All rights reserved.
//

import Foundation

/// Constants related Network Layer.
public struct NetworkConstants {
    
    /// API version in YYYY-MM-DD format.
    public static let clientVersion = "2018-02-08"
    
    /// API base URL.
    public static let baseURL = "https://api.coinbase.com"
    /// API v2 base URL.
    public static let baseURLv2 = "https://api.coinbase.com/v2"
    
    /// A range of status codes that indicates that the action requested by the SDK was received,
    /// understood and accepted.
    public static let validStatusCodes: Range<Int> = 200 ..< 300
    /// Status code recived when server couldn’t authenticate request.
    public static let unauthorizedStatusCode: Int = 401
    /// A set of status codes that do not contain response data.
    public static let emptyDataStatusCodes: Set<Int> = [204, 205]
}

/// List of available permissions.
///
/// Nesting of the permission constants mirrors API permissions pattern: `service-name:resource:action`.
///
public struct Scope {
    // swiftlint:disable nesting
    /// Wallet permissions.
    public struct Wallet {
        /// Account resource permissions.
        public struct Accounts {
            /// List user’s accounts and their balances.
            public static let read = "wallet:accounts:read"
            /// Update account (e.g. change name).
            public static let update = "wallet:accounts:update"
            /// Delete existing account.
            public static let delete = "wallet:accounts:delete"
        }
        /// Addresses resource permissions.
        public struct Addresses {
            /// List account’s crypto currency addresses.
            public static let read = "wallet:addresses:read"
            /// Create new crypto currency addresses for wallets.
            public static let create = "wallet:addresses:create"
        }
        /// Buys resource permissions.
        public struct Buys {
            /// List account’s buys.
            public static let read = "wallet:buys:read"
            /// Buy crypto currency.
            public static let create = "wallet:buys:create"
        }
        /// Checkouts permissions.
        public struct Checkouts {
            /// List user’s merchant checkouts.
            public static let read = "wallet:checkouts:read"
            /// Create a new merchant checkout.
            public static let create = "wallet:checkouts:create"
        }
        /// Deposits resource permissions.
        public struct Deposits {
            /// List account’s deposits.
            public static let read = "wallet:deposits:read"
            /// Create a new deposit.
            public static let create = "wallet:deposits:create"
        }
        /// Orders permissions.
        public struct Orders {
            /// List user’s merchant order.
            public static let read = "wallet:orders:read"
            /// Create a new merchant order.
            public static let create = "wallet:orders:create"
            /// Refund a merchant order.
            public static let refund = "wallet:orders:refund"
        }
        /// PaymentMethods resource permissions.
        public struct PaymentMethods {
            /// List user’s payment methods (e.g. bank accounts).
            public static let read = "wallet:payment-methods:read"
            /// Remove existing payment methods.
            public static let delete = "wallet:payment-methods:delete"
            /// Get detailed limits for payment methods (useful for performing buys and sells).
            /// This permission is to be used together with wallet:payment-methods:read.
            public static let limits = "wallet:payment-methods:limits"
        }
        /// Sells resource permissions.
        public struct Sells {
            /// List account’s sells.
            public static let read = "wallet:sells:read"
            /// Sell crypto currency.
            public static let create = "wallet:sells:create"
        }
        /// Transactions resource permissions.
        public struct Transactions {
            /// List account’s transactions.
            public static let read = "wallet:transactions:read"
            /// Send crypto currency.
            public static let send = "wallet:transactions:send"
            /// Bypass 2FA authentication when perform send transactions.
            public static let bypass2FASend = "wallet:transactions:send:bypass-2fa"
            /// Request crypto currency from a Coinbase user.
            public static let request = "wallet:transactions:request"
            /// Transfer funds between user’s two crypto currency accounts.
            public static let transfer = "wallet:transactions:transfer"
        }
        /// User resource permissions.
        public struct User {
            /// List detailed user information (public information is available without this permission).
            public static let read = "wallet:user:read"
            /// Update current user.
            public static let update = "wallet:user:update"
            /// Read current user’s email address.
            public static let email = "wallet:user:email"
        }
        /// Withdrawals resource permissions.
        public struct Withdrawals {
            /// List account’s withdrawals.
            public static let read = "wallet:withdrawals:read"
            /// Create a new withdrawal.
            public static let create = "wallet:withdrawals:create"
        }
    }
    // swiftlint:enable nesting
}

/// Additional authorization meta parameters.
///
public struct Meta {
    
    /// List of additional
    /// [Send limits](https://developers.coinbase.com/docs/wallet/coinbase-connect/permissions#send-limits) parameters.
    ///
    public struct SendLimit {
        /// A limit to the amount of money your application can send from the user’s account. This will be displayed on the authorize screen.
        public static let amount = "send_limit_amount"
        /// Currency of `send_limit_amount` in ISO format, ex. `BTC`, `USD`.
        public static let currency = "send_limit_currency"
        /// How often the send money limit expires. Default is `month` - allowed values are `day`, `month` and `year`.
        public static let period = "send_limit_period"
    }
    
    /// Name for this session (not a name for the application).
    ///
    /// Use it to provide identifying information if your app is often authorized multiple times.
    ///
    public static let name = "name"
    
}

/// Constants with path components of API endpoints.
public struct PathConstants {
    
    public static let accounts = "accounts"
    public static let addresses = "addresses"
    public static let auth = "auth"
    public static let buy = "buy"
    public static let commit = "commit"
    public static let complete = "complete"
    public static let currencies = "currencies"
    public static let exchangeRates = "exchange-rates"
    public static let oauth = "oauth"
    public static let paymentMethods = "payment-methods"
    public static let prices = "prices"
    public static let primary = "primary"
    public static let resend = "resend"
    public static let revoke = "revoke"
    public static let sell = "sell"
    public static let spot = "spot"
    public static let time = "time"
    public static let token = "token"
    public static let transactions = "transactions"
    public static let user = "user"
    public static let users = "users"
    
}

/// Keys for required HTTP Headers to send with requests.
internal struct HeaderKeys {
    
    static let authorization = "Authorization"
    static let userAgent = "User-Agent"
    static let accept = "Accept"
    static let acceptEncoding = "Accept-Encoding"
    static let contentType = "Content-Type"
    static let acceptLanguage = "Accept-Language"
    
    static let cbVersion = "CB-VERSION"
    static let cbClient = "CB-CLIENT"
    static let cb2FA = "CB-2FA-Token"
    
    static let xIDFV = "X-IDFV"
    
    static let xDeviceModel = "X-Device-Model"
    static let xDeviceBrand = "X-Device-Brand"
    static let xDeviceManufacturer = "X-Device-Manufacturer"
    static let xDeviceName = "X-Device-Name"
    
    static let xOSName = "X-Os-Name"
    static let xOSVersion = "X-Os-Version"
    
    static let xAppBundleID = "X-App-BundleID"
    static let xAppName = "X-App-Name"
    static let xAppVersion = "X-App-Version"
    static let xAppBuildNumber = "X-App-Build-Number"
    
}

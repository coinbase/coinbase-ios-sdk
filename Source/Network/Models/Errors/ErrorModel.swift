//
//  ClientError.swift
//  Coinbase iOS
//
//  Copyright © 2018 Coinbase, Inc. All rights reserved.
//

import Foundation

/// Represents an error model that may be returned by server.
///
/// **Online API Documentation**
///
/// [Errors](https://developers.coinbase.com/api/v2#errors)
///
open class ErrorModel: Decodable {

    /// Error code.
    ///
    /// See also: `ClientErrorID` constants.
    ///
    public let id: String
    /// Human readable message.
    ///
    /// May be localized, according to request headers.
    public let message: String
    /// Link to the documentation.
    public let url: String?

    private enum CodingKeys: String, CodingKey {
        case id, message, url
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        message = try values.decode(String.self, forKey: .message)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}

/// List of available error codes.
public struct ClientErrorID {
    /// When sending money over 2fa limit.
    ///
    /// Status Code: `402`.
    public static let twoFactorRequired = "two_factor_required"
    /// Missing parameter.
    ///
    /// Status Code: `400`.
    public static let paramRequired = "param_required"
    /// Unable to validate POST/PUT.
    ///
    /// Status Code: `400`.
    public static let validationError = "validation_error"
    /// Invalid request.
    ///
    /// Status Code: `400`.
    public static let invalidRequest = "invalid_request"
    /// User’s personal detail required to complete this request.
    ///
    /// Status Code: `400`.
    public static let personalDetailsRequired = "personal_details_required"
    /// Identity verification is required to complete this request.
    ///
    /// Status Code: `400`.
    public static let identityVerificationRequired = "identity_verification_required"
    /// Document verification is required to complete this request.
    ///
    /// Status Code: `400`.
    public static let jumioVerificationRequired = "jumio_verification_required"
    /// Document verification including face match is required to complete this request.
    ///
    /// Status Code: `400`.
    public static let jumioFaceMatchVerificationRequired = "jumio_face_match_verification_required"
    /// User has not verified their email.
    ///
    /// Status Code: `400`.
    public static let unverifiedEmail = "unverified_email"
    /// Invalid auth (generic).
    ///
    /// Status Code: `401`.
    public static let authenticationError = "authentication_error"
    /// Invalid Oauth token.
    ///
    /// Status Code: `401`.
    public static let invalidToken = "invalid_token"
    /// Revoked Oauth token.
    ///
    /// Status Code: `401`.
    public static let revokedToken = "revoked_token"
    /// Expired Oauth token.
    ///
    /// Status Code: `401`.
    public static let expiredToken = "expired_token"
    /// User hasn’t authenticated necessary scope.
    ///
    /// Status Code: `403`.
    public static let invalidScope = "invalid_scope"
    /// Resource not found.
    ///
    /// Status Code: `404`.
    public static let notFound = "not_found"
    /// Rate limit exceeded.
    ///
    /// Status Code: `429`.
    public static let rateLimitExceeded = "rate_limit_exceeded"
    /// Internal server error.
    ///
    /// Status Code: `500`.
    public static let internalServerError = "internal_server_error"
}

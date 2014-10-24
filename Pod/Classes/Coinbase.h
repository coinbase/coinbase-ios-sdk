#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger, CoinbaseAuthenticationType) {
    CoinbaseAuthenticationTypeAPIKey,
    CoinbaseAuthenticationTypeOAuth
};

typedef NS_ENUM(NSUInteger, CoinbaseRequestType) {
    CoinbaseRequestTypeGet,
    CoinbaseRequestTypePost,
    CoinbaseRequestTypePut,
    CoinbaseRequestTypeDelete
};

/// Block type that takes a JSON object. Used when an API request has been successful.
typedef void (^CoinbaseSuccessBlock)(NSDictionary *jsonObject);

/// Block type that takes a NSError. Used when an API request has failed.
typedef void (^CoinbaseFailureBlock)(NSError *error);

/// NSError domain for Coinbase errors.
extern NSString *const CoinbaseErrorDomain;

/// NSError codes for Coinbase errors.
typedef NS_ENUM(NSInteger, CoinbaseErrorCode) {
    CoinbaseOAuthError,
    CoinbaseServerErrorUnknown,
    CoinbaseServerErrorWithMessage
};

/// The `Coinbase` class is the interface to the Coinbase API. Create a `Coinbase` object using
/// `coinbaseWithOAuthAccessToken:` or `coinbaseWithApiKey:secret:` to call API methods. The
/// `Coinbase` class also includes helper methods for OAuth authentication.
@interface Coinbase : NSObject

/// Start the OAuth authentication process. This will open a different application to complete the
/// authentication flow.
+ (void)startOAuthAuthenticationWithClientId:(NSString *)clientId
                                       scope:(NSString *)scope
                                 redirectUri:(NSString *)redirectUri
                                        meta:(NSDictionary *)meta;

/// Finish the OAuth authentication process. This should be called when your application is opened
/// for a Coinbase OAuth URI.
///
/// If you pass your client secret to `clientSecret`, the OAuth access grant will be exchanged for tokens
/// on the device and returned to your in the `success` callback. If you pass nil to `clientSecret`, the
/// OAuth access grant code will be returned to your `success` callback, so you can send it to your server and
/// exchange it for tokens there. If your application has a server side component, the second approach is recommended,
/// as it prevents disclosure of the client secret to the client side.
+ (void)finishOAuthAuthenticationForUrl:(NSURL *)url
                               clientId:(NSString *)clientId
                           clientSecret:(NSString *)clientSecret
                                success:(CoinbaseSuccessBlock)success
                                failure:(CoinbaseFailureBlock)failure;

/// Get new tokens using a refresh token.
+ (void)getOAuthTokenForRefreshToken:(NSString *)refreshToken
                            clientId:(NSString *)clientId
                        clientSecret:(NSString *)clientSecret
                             success:(CoinbaseSuccessBlock)success
                             failure:(CoinbaseFailureBlock)failure;

/// Create a Coinbase object for an OAuth access token. Please note that when this access token
/// expires, requests made on this object will start failing with a 401 Unauthorized error. Obtain new tokens
/// with your refresh token if this occurs.
+ (Coinbase *)coinbaseWithOAuthAccessToken:(NSString *)accessToken;

/// Create a Coinbase object for an API key and secret.
+ (Coinbase *)coinbaseWithApiKey:(NSString *)key
                          secret:(NSString *)secret;

- (void)doGet:(NSString *)path
                parameters:(NSDictionary *)parameters
                   success:(CoinbaseSuccessBlock)success
                   failure:(CoinbaseFailureBlock)failure;

- (void)doPost:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(CoinbaseSuccessBlock)success
                    failure:(CoinbaseFailureBlock)failure;

- (void)doPut:(NSString *)path
                parameters:(NSDictionary *)parameters
                   success:(CoinbaseSuccessBlock)success
                   failure:(CoinbaseFailureBlock)failure;

- (void)doDelete:(NSString *)path
                   parameters:(NSDictionary *)parameters
                      success:(CoinbaseSuccessBlock)success
                      failure:(CoinbaseFailureBlock)failure;

@property CoinbaseAuthenticationType authenticationType;
@property (strong) NSString *apiKey;
@property (strong) NSString *apiSecret;
@property (strong) NSString *accessToken;

@end

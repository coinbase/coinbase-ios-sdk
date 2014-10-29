#import <Foundation/Foundation.h>
#import "AFNetworking.h"

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
/// `coinbaseWithOAuthAccessToken:` or `coinbaseWithApiKey:secret:` to call API methods.
@interface Coinbase : NSObject

/// Create a Coinbase object for an OAuth access token. Please note that when this access token
/// expires, requests made on this object will start failing with a 401 Unauthorized error. Obtain new tokens
/// with your refresh token if this occurs.
+ (Coinbase *)coinbaseWithOAuthAccessToken:(NSString *)accessToken;

/// Create a Coinbase object for an API key and secret.
+ (Coinbase *)coinbaseWithApiKey:(NSString *)key
                          secret:(NSString *)secret;

/// Make a GET request to the Coinbase API.
- (void)doGet:(NSString *)path
                parameters:(NSDictionary *)parameters
                   success:(CoinbaseSuccessBlock)success
                   failure:(CoinbaseFailureBlock)failure;

/// Make a POST request to the Coinbase API.
- (void)doPost:(NSString *)path
                 parameters:(NSDictionary *)parameters
                    success:(CoinbaseSuccessBlock)success
                    failure:(CoinbaseFailureBlock)failure;

/// Make a PUT request to the Coinbase API.
- (void)doPut:(NSString *)path
                parameters:(NSDictionary *)parameters
                   success:(CoinbaseSuccessBlock)success
                   failure:(CoinbaseFailureBlock)failure;

/// Make a DELETE request to the Coinbase API.
- (void)doDelete:(NSString *)path
                   parameters:(NSDictionary *)parameters
                      success:(CoinbaseSuccessBlock)success
                      failure:(CoinbaseFailureBlock)failure;

@end

#import <Foundation/Foundation.h>
#import "CoinbaseDefines.h"

/// HTTP methods for use with the Coinbase API.
typedef NS_ENUM(NSUInteger, CoinbaseRequestType) {
    CoinbaseRequestTypeGet,
    CoinbaseRequestTypePost,
    CoinbaseRequestTypePut,
    CoinbaseRequestTypeDelete
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

/// Create a Coinbase object with no authentication. You can only use unauthenticated APIs with this client.
+ (Coinbase *)unauthenticatedCoinbase;

/// Base URL that will be used when making API requests. Defaults to "https://api.coinbase.com/"
@property (nonatomic, strong) NSURL *baseURL;

/// Make a GET request to the Coinbase API.
- (void)doGet:(NSString *)path
                parameters:(NSDictionary *)parameters
                completion:(CoinbaseCompletionBlock)completion;

/// Make a POST request to the Coinbase API.
- (void)doPost:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(CoinbaseCompletionBlock)completion;

/// Make a PUT request to the Coinbase API.
- (void)doPut:(NSString *)path
   parameters:(NSDictionary *)parameters
   completion:(CoinbaseCompletionBlock)completion;

/// Make a DELETE request to the Coinbase API.
- (void)doDelete:(NSString *)path
      parameters:(NSDictionary *)parameters
      completion:(CoinbaseCompletionBlock)completion;

/// Make a GET request to the Coinbase API.
- (void)doGet:(NSString *)path
   parameters:(NSDictionary *)parameters
      headers:(NSDictionary *)headers
   completion:(CoinbaseCompletionBlock)completion;

/// Make a POST request to the Coinbase API.
- (void)doPost:(NSString *)path
    parameters:(NSDictionary *)parameters
       headers:(NSDictionary *)headers
    completion:(CoinbaseCompletionBlock)completion;

/// Make a PUT request to the Coinbase API.
- (void)doPut:(NSString *)path
   parameters:(NSDictionary *)parameters
      headers:(NSDictionary *)headers
   completion:(CoinbaseCompletionBlock)completion;

/// Make a DELETE request to the Coinbase API.
- (void)doDelete:(NSString *)path
      parameters:(NSDictionary *)parameters
         headers:(NSDictionary *)headers
      completion:(CoinbaseCompletionBlock)completion;

/// Make a request to the Coinbase API. Specify the HTTP method as a CoinbaseRequestType enum member.
- (void)doRequestType:(CoinbaseRequestType)type
                 path:(NSString *)path
           parameters:(NSDictionary *)parameters
           completion:(CoinbaseCompletionBlock)completion;

/// Make a request to the Coinbase API. Specify the HTTP method as a CoinbaseRequestType enum member.
- (void)doRequestType:(CoinbaseRequestType)type
                 path:(NSString *)path
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
           completion:(CoinbaseCompletionBlock)completion;

@end

#import <Foundation/Foundation.h>
#import "Coinbase.h"

/// Block type used for successful authorization code requests.
typedef void (^CoinbaseOAuthCodeSuccessBlock)(NSString *code);

/// `CoinbaseOAuth` contains methods to authenticate users through OAuth2. After obtaining an
/// access token using this class, you can call Coinbase API methods
/// using `[Coinbase coinbaseWithOAuthAccessToken:]`.
@interface CoinbaseOAuth : NSObject


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
/// OAuth authorization code will be returned to your `success` callback, so you can send it to your server and
/// exchange it for tokens there. If your application has a server side component, the second approach is recommended,
/// as it prevents disclosure of the client secret to the client side.
+ (void)finishOAuthAuthenticationForUrl:(NSURL *)url
                               clientId:(NSString *)clientId
                           clientSecret:(NSString *)clientSecret
                                success:(CoinbaseSuccessBlock)success
                                failure:(CoinbaseFailureBlock)failure;

/// Get new tokens using a refresh token.
+ (void)getOAuthTokensForRefreshToken:(NSString *)refreshToken
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                              success:(CoinbaseSuccessBlock)success
                              failure:(CoinbaseFailureBlock)failure;

/// Get new tokens using an authorization code.
+ (void)getOAuthTokensForCode:(NSString *)code
                  redirectUri:(NSString *)redirectUri
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                      success:(CoinbaseSuccessBlock)success
                      failure:(CoinbaseFailureBlock)failure;

/// Get an OAauth authorization code for the user using a non-interactive login process. Most apps
/// should not use this. Only use this method if you cannot implement the standard OAuth authentication process.
/// This method requires that the user enters their username and password inside your app, which is insecure
/// behaviour and is discouraged.
///
/// After receiving a successful callback from this method, you will need to exchange the code for access
/// and refresh tokens using `getOAuthTokensForCode`.
+ (void)doOAuthAuthenticationWithUsername:(NSString *)username
                                 password:(NSString *)password
                                    token:(NSString *)token
                                 clientId:(NSString *)clientId
                                    scope:(NSString *)scope
                              redirectUri:(NSString *)redirectUri
                                     meta:(NSDictionary *)meta
                                  success:(CoinbaseOAuthCodeSuccessBlock)success
                                  failure:(CoinbaseFailureBlock)failure;

@end

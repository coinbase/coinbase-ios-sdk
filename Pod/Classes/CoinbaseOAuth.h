#import <Foundation/Foundation.h>
#import "Coinbase.h"

/// `CoinbaseOAuth` contains methods to authenticate users through OAuth2. After obtaining an
/// access token using this class, you can call Coinbase API methods
/// using `[Coinbase coinbaseWithOAuthAccessToken:]`.
@interface CoinbaseOAuth : NSObject

/// Test if the Coinbase app is installed and if the OAuth authentication process will use the Coinbase
/// app to offer an easier authentication process. Can be used to make the Coinbase OAuth sign in action
/// more prominent if the app is installed (thus indicating the user has an interest in Coinbase).
+ (BOOL)isAppOAuthAuthenticationAvailable;

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
                             completion:(CoinbaseCompletionBlock)completion;

/// Get new tokens using a refresh token.
+ (void)getOAuthTokensForRefreshToken:(NSString *)refreshToken
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                           completion:(CoinbaseCompletionBlock)completion;

/// Get new tokens using an authorization code.
+ (void)getOAuthTokensForCode:(NSString *)code
                  redirectUri:(NSString *)redirectUri
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                   completion:(CoinbaseCompletionBlock)completion;

@end

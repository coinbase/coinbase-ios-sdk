//
//  CoinbaseOAuth.m
//  Pods
//
//  Created by Isaac Waller on 10/28/14.
//
//

#import "CoinbaseOAuth.h"

NSString *const CoinbaseOAuthErrorUserInfoKey = @"CoinbaseOAuthError";

@implementation CoinbaseOAuth

static BOOL shouldUseSandbox = NO;

+ (BOOL)isAppOAuthAuthenticationAvailable {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.coinbase.oauth-authorize://authorize"]];
}

+ (CoinbaseOAuthAuthenticationMechanism)startOAuthAuthenticationWithClientId:(NSString *)clientId
                                                                       scope:(NSString *)scope
                                                                 redirectUri:(NSString *)redirectUri
                                                                        meta:(NSDictionary *)meta {
    NSString *path = [NSString stringWithFormat: @"/oauth/authorize?response_type=code&client_id=%@", clientId];
    if (scope) {
        path = [path stringByAppendingFormat:@"&scope=%@", [self URLEncodedStringFromString:scope]];
    }
    if (redirectUri) {
        path = [path stringByAppendingFormat:@"&redirect_uri=%@", [self URLEncodedStringFromString:redirectUri]];
    }
    if (meta) {
        for (NSString *key in meta) {
            path = [path stringByAppendingFormat:@"&meta[%@]=%@", [self URLEncodedStringFromString:key], [self URLEncodedStringFromString:meta[key]]];
        }
    }

    CoinbaseOAuthAuthenticationMechanism mechanism = CoinbaseOAuthMechanismNone;
    NSURL *coinbaseAppUrl = [NSURL URLWithString:[NSString stringWithFormat:@"com.coinbase.oauth-authorize:%@", path]];
    BOOL appSwitchSuccessful = NO;
    if ([[UIApplication sharedApplication] canOpenURL:coinbaseAppUrl]) {
        appSwitchSuccessful = [[UIApplication sharedApplication] openURL:coinbaseAppUrl];
        if (appSwitchSuccessful) {
            mechanism = CoinbaseOAuthMechanismApp;
        }
    }

    if (!appSwitchSuccessful) {
        NSString *subdomain = @"www";
        if (shouldUseSandbox) {
            subdomain = @"sandbox";
        }
        NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.coinbase.com%@", subdomain, path]];
        BOOL browserSwitchSuccessful = [[UIApplication sharedApplication] openURL:webUrl];
        if (browserSwitchSuccessful) {
            mechanism = CoinbaseOAuthMechanismBrowser;
        }
    }

    return mechanism;
}

+ (void)finishOAuthAuthenticationForUrl:(NSURL *)url
                               clientId:(NSString *)clientId
                           clientSecret:(NSString *)clientSecret
                             completion:(CoinbaseCompletionBlock)completion {
    // Parse params from URL's query string
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        NSString *key = [elts objectAtIndex:0];
        NSString *value = [elts objectAtIndex:1];

        params[key] = value;
    }

    // Get code from URL and check for error.
    NSString *code = params[@"code"];
    
    if (params[@"error_description"] != nil) {
        NSString *errorDescription = [[params[@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                                      stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: errorDescription, CoinbaseOAuthErrorUserInfoKey: (params[@"error"] ?: [NSNull null]) };
        NSError *error = [NSError errorWithDomain:CoinbaseErrorDomain
                                             code:CoinbaseOAuthError
                                         userInfo:userInfo];
        completion(nil, error);
        return;
    } else if (!code) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Malformed URL." };
        NSError *error = [NSError errorWithDomain:CoinbaseErrorDomain
                                             code:CoinbaseOAuthError
                                         userInfo:userInfo];
        completion(nil, error);
        return;
    } else if (!clientSecret) {
        // Do not make token request on client side
        completion(@{@"code": code}, nil);
        return;
    }
    
    // Make token request
    // Obtain original redirect URI by removing 'code' parameter from URI
    NSString *redirectUri = [[url absoluteString] stringByReplacingOccurrencesOfString:[url query] withString:@""];
    redirectUri = [redirectUri substringToIndex:redirectUri.length - 1]; // Strip off trailing '?'
    [CoinbaseOAuth getOAuthTokensForCode:code
                             redirectUri:redirectUri
                                clientId:clientId
                            clientSecret:clientSecret
                              completion:completion];
    return;
}

+ (void)getOAuthTokensForCode:(NSString *)code
                  redirectUri:(NSString *)redirectUri
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                   completion:(CoinbaseCompletionBlock)completion {
    NSDictionary *params = @{ @"grant_type": @"authorization_code",
                              @"code": code,
                              @"redirect_uri": redirectUri,
                              @"client_id": clientId,
                              @"client_secret": clientSecret };
    [CoinbaseOAuth doOAuthPostToPath:@"token" withParams:params completion:completion];
}

+ (void)getOAuthTokensForRefreshToken:(NSString *)refreshToken
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                           completion:(CoinbaseCompletionBlock)completion {
    NSDictionary *params = @{ @"grant_type": @"refresh_token",
                              @"refresh_token": refreshToken,
                              @"client_id": clientId,
                              @"client_secret": clientSecret };
    [CoinbaseOAuth doOAuthPostToPath:@"token" withParams:params completion:completion];
}

+ (void)doOAuthPostToPath:(NSString *)path
               withParams:(NSDictionary *)params
               completion:(CoinbaseCompletionBlock)completion {

    NSString *subdomain = @"www";
    if (shouldUseSandbox) {
        subdomain = @"sandbox";
    }
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.coinbase.com/oauth/%@", subdomain, path]];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];

    // Create POST data (OAuth APIs only accept standard URL-format data, not JSON)
    NSMutableArray *components = [NSMutableArray new];
    NSString *encodedKey, *encodedValue;
    for (NSString *key in params) {
        encodedKey = [CoinbaseOAuth URLEncodedStringFromString:key];
        encodedValue = [CoinbaseOAuth URLEncodedStringFromString:[params objectForKey:key]];
        [components addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
    }

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSError *error = nil;
    NSData *data = [[components componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    if (error) {
        completion(nil, error);
        return;
    }
    NSURLSessionUploadTask *task;
    task = [session uploadTaskWithRequest:request
                                 fromData:data
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (!error) {
                                NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                                NSDictionary *parsedBody = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                if (!error) {
                                    if ([parsedBody objectForKey:@"error"] || [httpResponse statusCode] > 300) {
                                        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: [parsedBody objectForKey:@"error"] };
                                        error = [NSError errorWithDomain:CoinbaseErrorDomain
                                                                    code:CoinbaseOAuthError
                                                                userInfo:userInfo];
                                    } else {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            completion(parsedBody, nil);
                                        });
                                        return;
                                    }
                                }
                            }

                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(nil, error);
                            });
                        }];
    [task resume];
}

+ (NSString *)URLEncodedStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

+ (void)setSandboxEnabled:(BOOL)sandboxEnabled {
    shouldUseSandbox = sandboxEnabled;
}

@end

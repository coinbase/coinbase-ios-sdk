//
//  CoinbaseOAuth.m
//  Pods
//
//  Created by Isaac Waller on 10/28/14.
//
//

#import "CoinbaseOAuth.h"

@implementation CoinbaseOAuth

+ (BOOL)isAppOAuthAuthenticationAvailable {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"com.coinbase.oauth-authorize://authorize"]];
}

+ (void)startOAuthAuthenticationWithClientId:(NSString *)clientId
                                       scope:(NSString *)scope
                                 redirectUri:(NSString *)redirectUri
                                        meta:(NSDictionary *)meta {
    NSString *path = [NSString stringWithFormat: @"/oauth/authorize?response_type=code&client_id=%@", clientId];
    if (scope) {
        path = [path stringByAppendingFormat:@"&scope=%@", [scope stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (redirectUri) {
        path = [path stringByAppendingFormat:@"&redirect_uri=%@", [redirectUri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    if (meta) {
        for (NSString *key in meta) {
            path = [path stringByAppendingFormat:@"&meta[%@]=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[meta objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    NSURL *coinbaseAppUrl = [NSURL URLWithString:[NSString stringWithFormat:@"com.coinbase.oauth-authorize:%@", path]];
    if ([[UIApplication sharedApplication] canOpenURL:coinbaseAppUrl]) {
        [[UIApplication sharedApplication] openURL:coinbaseAppUrl];
    } else {
        NSURL *webUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.coinbase.com%@", path]];
        [[UIApplication sharedApplication] openURL:webUrl];
    }
}

+ (void)finishOAuthAuthenticationForUrl:(NSURL *)url
                               clientId:(NSString *)clientId
                           clientSecret:(NSString *)clientSecret
                             completion:(CoinbaseCompletionBlock)completion {
    
    // Get code from URL and check for error.
    NSString *code = nil;
    for (NSString *param in [url.query componentsSeparatedByString:@"&"]) {
        NSArray *elts = [param componentsSeparatedByString:@"="];
        NSString *key = [elts objectAtIndex:0];
        NSString *value = [elts objectAtIndex:1];
        
        if ([key isEqualToString:@"code"]) {
            code = value;
        } else if ([key isEqualToString:@"error_description"]) {
            value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: value };
            NSError *error = [NSError errorWithDomain:CoinbaseErrorDomain
                                                 code:CoinbaseOAuthError
                                             userInfo:userInfo];
            completion(nil, error);
            return;
        }
    }
    if (!code) {
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

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.coinbase.com/oauth/%@", path]];
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

@end

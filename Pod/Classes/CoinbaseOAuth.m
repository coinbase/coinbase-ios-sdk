//
//  CoinbaseOAuth.m
//  Pods
//
//  Created by Isaac Waller on 10/28/14.
//
//

#import "CoinbaseOAuth.h"

@implementation CoinbaseOAuth

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
                                success:(CoinbaseSuccessBlock)success
                                failure:(CoinbaseFailureBlock)failure {
    
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
            failure(error);
            return;
        }
    }
    if (!code) {
        NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Malformed URL." };
        NSError *error = [NSError errorWithDomain:CoinbaseErrorDomain
                                             code:CoinbaseOAuthError
                                         userInfo:userInfo];
        failure(error);
        return;
    } else if (!clientId) {
        // Do not make token request on client side
        success(@{@"code": code});
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
                                 success:success
                                 failure:failure];
    return;
}

+ (void)getOAuthTokensForCode:(NSString *)code
                  redirectUri:(NSString *)redirectUri
                     clientId:(NSString *)clientId
                 clientSecret:(NSString *)clientSecret
                      success:(CoinbaseSuccessBlock)success
                      failure:(CoinbaseFailureBlock)failure {
    NSDictionary *params = @{ @"grant_type": @"authorization_code",
                              @"code": code,
                              @"redirect_uri": redirectUri,
                              @"client_id": clientId,
                              @"client_secret": clientSecret };
    [CoinbaseOAuth doOAuthPostToPath:@"token" withParams:params success:success failure:failure];
}

+ (void)getOAuthTokensForRefreshToken:(NSString *)refreshToken
                             clientId:(NSString *)clientId
                         clientSecret:(NSString *)clientSecret
                              success:(CoinbaseSuccessBlock)success
                              failure:(CoinbaseFailureBlock)failure {
    NSDictionary *params = @{ @"grant_type": @"refresh_token",
                              @"refresh_token": refreshToken,
                              @"client_id": clientId,
                              @"client_secret": clientSecret };
    [CoinbaseOAuth doOAuthPostToPath:@"token" withParams:params success:success failure:failure];
}


+ (void)doOAuthAuthenticationWithUsername:(NSString *)username
                                 password:(NSString *)password
                                    token:(NSString *)token
                                 clientId:(NSString *)clientId
                             clientSecret:(NSString *)clientSecret
                                    scope:(NSString *)scope
                              redirectUri:(NSString *)redirectUri
                                     meta:(NSDictionary *)meta
                                  success:(CoinbaseOAuthCodeSuccessBlock)success
                                  failure:(CoinbaseFailureBlock)failure {
    NSMutableDictionary *params = [@{ @"client_id": clientId,
                                      @"client_secret": clientSecret,
                                      @"username": username,
                                      @"password": password,
                                      @"scope": scope } mutableCopy];
    if (token) {
        [params setValue:token forKey:@"token"];
    }
    if (redirectUri) {
        [params setValue:redirectUri forKey:@"redirect_uri"];
    }
    if (meta) {
        for (NSString *key in meta) {
            [params setValue:[meta objectForKey:key] forKey:[NSString stringWithFormat:@"&meta[%@]", key]];
        }
    }
    [CoinbaseOAuth doOAuthPostToPath:@"authorize/with_credentials" withParams:params success:^(NSDictionary * response) {
        success([response objectForKey:@"code"]);
    } failure:failure];
}

+ (void)doOAuthPostToPath:(NSString *)path
               withParams:(NSDictionary *)params
                  success:(CoinbaseSuccessBlock)success
                  failure:(CoinbaseFailureBlock)failure {

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
        failure(error);
        return;
    }
    NSURLSessionUploadTask *task;
    task = [session uploadTaskWithRequest:request
                                 fromData:data
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                            if (error) {
                                failure(error);
                                return;
                            }
                            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
                            NSDictionary *parsedBody = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                            if (error) {
                                failure(error);
                                return;
                            }
                            if ([parsedBody objectForKey:@"error"] || [httpResponse statusCode] > 300) {
                                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: [parsedBody objectForKey:@"error"] };
                                NSError *error = [NSError errorWithDomain:CoinbaseErrorDomain
                                                                     code:CoinbaseOAuthError
                                                                 userInfo:userInfo];
                                failure(error);
                                return;
                            }
                            success(parsedBody);
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

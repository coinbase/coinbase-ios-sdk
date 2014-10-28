#import "Coinbase.h"
#import <CommonCrypto/CommonHMAC.h>

NSString *const CoinbaseErrorDomain = @"CoinbaseErrorDomain";

@interface Coinbase ()

@property CoinbaseAuthenticationType authenticationType;
@property (strong) NSString *apiKey;
@property (strong) NSString *apiSecret;
@property (strong) NSString *accessToken;

@end

@implementation Coinbase

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
    [Coinbase getOAuthTokensForCode:code
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
    [Coinbase doOAuthPostToPath:@"token" withParams:params success:success failure:failure];
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
    [Coinbase doOAuthPostToPath:@"token" withParams:params success:success failure:failure];
}


+ (void)doOAuthAuthenticationWithUsername:(NSString *)username
                                 password:(NSString *)password
                                    token:(NSString *)token
                                 clientId:(NSString *)clientId
                             clientSecret:(NSString *)clientSecret
                                    scope:(NSString *)scope
                              redirectUri:(NSString *)redirectUri
                                     meta:(NSDictionary *)meta
                                  success:(CoinbaseSuccessBlock)success
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
    [Coinbase doOAuthPostToPath:@"authorize/with_credentials" withParams:params success:success failure:failure];
}

+ (void)doOAuthPostToPath:(NSString *)path
               withParams:(NSDictionary *)params
                  success:(CoinbaseSuccessBlock)success
                  failure:(CoinbaseFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:[NSString stringWithFormat:@"https://www.coinbase.com/oauth/%@", path] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
}

+ (Coinbase *)coinbaseWithOAuthAccessToken:(NSString *)accessToken {
    return [[self alloc] initWithOAuthAccessToken:accessToken];
}

+ (Coinbase *)coinbaseWithApiKey:(NSString *)key secret:(NSString *)secret {
    return [[self alloc] initWithApiKey:key secret:secret];
}

- (instancetype)initWithOAuthAccessToken:(NSString *)accessToken {
    self = [self init];
    if (self) {
        self.authenticationType = CoinbaseAuthenticationTypeOAuth;
        self.accessToken = accessToken;
    }
    return self;
}

- (instancetype)initWithApiKey:(NSString *)key secret:(NSString *)secret {
    self = [self init];
    if (self) {
        self.authenticationType = CoinbaseAuthenticationTypeAPIKey;
        self.apiKey = key;
        self.apiSecret = secret;
    }
    return self;
}

- (void)requestSuccess:(AFHTTPRequestOperation *)operation
              response:(id)responseObject
               success:(CoinbaseSuccessBlock)success
               failure:(CoinbaseFailureBlock)failure {
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
    if (error) {
        failure(error);
        return;
    }
    if ([response objectForKey:@"error"] || [response objectForKey:@"errors"]) {
        NSDictionary *userInfo;
        if ([response objectForKey:@"error"]) {
            userInfo = @{ @"error": [response objectForKey:@"error"] };
        } else {
            userInfo = @{ @"errors": [response objectForKey:@"errors"] };
        }
        failure([NSError errorWithDomain:CoinbaseErrorDomain code:CoinbaseServerErrorWithMessage userInfo:userInfo]);
        return;
    }
    success(response);
}

// http://stackoverflow.com/a/16458798/764272
- (NSString *)generateSignature:(NSString *)body {
    const char *cKey  = [self.apiSecret cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [body cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    
    for (int i = 0; i < HMACData.length; ++i)
        HMAC = [HMAC stringByAppendingFormat:@"%02lx", (unsigned long)buffer[i]];
    
    return HMAC;
}

- (void)doRequestType:(CoinbaseRequestType)type
                 path:(NSString *)path
           parameters:(NSDictionary *)parameters
              success:(CoinbaseSuccessBlock)success
              failure:(CoinbaseFailureBlock)failure {
    
    NSString *body = nil;
    if (type == CoinbaseRequestTypeGet || type == CoinbaseRequestTypeDelete) {
        // Parameters need to be appended to URL
        NSMutableArray *parts = [NSMutableArray array];
        NSString *encodedKey, *encodedValue;
        for (NSString *key in parameters) {
            encodedKey = [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            encodedValue = [[parameters objectForKey:key] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
        path = [[parts componentsJoinedByString:@"&"] stringByAppendingString:path];
    } else if (parameters) {
        // POST body is encoded as JSON
        NSError *error = nil;
        body = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error] encoding:NSUTF8StringEncoding];
        if (error) {
            failure(error);
            return;
        }
    }

    NSURL *baseURL = [NSURL URLWithString:@"https://coinbase.com/api/v1/"];
    NSURL *URL = [NSURL URLWithString:path relativeToURL:baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    if (body) {
        [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    switch (type) {
        case CoinbaseRequestTypeGet:
            [request setHTTPMethod:@"GET"];
            break;
        case CoinbaseRequestTypePost:
            [request setHTTPMethod:@"POST"];
            break;
        case CoinbaseRequestTypeDelete:
            [request setHTTPMethod:@"DELETE"];
            break;
        case CoinbaseRequestTypePut:
            [request setHTTPMethod:@"PUT"];
            break;
    }

    if (self.authenticationType == CoinbaseAuthenticationTypeAPIKey) {
        // HMAC auth
        NSInteger nonce = [[NSDate date] timeIntervalSince1970] * 100000;
        NSString *toBeSigned = [NSString stringWithFormat:@"%ld%@%@", (long)nonce, [URL absoluteString], body ? body : @""];
        NSString *signature = [self generateSignature: toBeSigned];
        [request setValue:self.apiKey forHTTPHeaderField:@"ACCESS_KEY"];
        [request setValue:signature forHTTPHeaderField:@"ACCESS_SIGNATURE"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)nonce] forHTTPHeaderField:@"ACCESS_NONCE"];
    } else {
        // OAuth
        [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    }


    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestSuccess:operation response:responseObject success:success failure:failure];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    [op start];
}

- (void)doGet:(NSString *)path
   parameters:(NSDictionary *)parameters
      success:(CoinbaseSuccessBlock)success
      failure:(CoinbaseFailureBlock)failure {
    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters success:success failure:failure];
}

- (void)doPost:(NSString *)path
    parameters:(NSDictionary *)parameters
       success:(CoinbaseSuccessBlock)success
       failure:(CoinbaseFailureBlock)failure {
    [self doRequestType:CoinbaseRequestTypePost path:path parameters:parameters success:success failure:failure];
}

- (void)doPut:(NSString *)path
   parameters:(NSDictionary *)parameters
      success:(CoinbaseSuccessBlock)success
      failure:(CoinbaseFailureBlock)failure {
    [self doRequestType:CoinbaseRequestTypePut path:path parameters:parameters success:success failure:failure];
}

- (void)doDelete:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(CoinbaseSuccessBlock)success
         failure:(CoinbaseFailureBlock)failure {
    [self doRequestType:CoinbaseRequestTypeDelete path:path parameters:parameters success:success failure:failure];
}

@end

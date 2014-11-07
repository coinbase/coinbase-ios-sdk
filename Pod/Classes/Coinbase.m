#import "Coinbase.h"
#import <CommonCrypto/CommonHMAC.h>

NSString *const CoinbaseErrorDomain = @"CoinbaseErrorDomain";

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

@interface Coinbase ()

@property CoinbaseAuthenticationType authenticationType;
@property (strong) NSString *apiKey;
@property (strong) NSString *apiSecret;
@property (strong) NSString *accessToken;

@end

@implementation Coinbase

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

- (void)requestSuccess:(NSHTTPURLResponse *)operation
              response:(NSData *)data
               success:(CoinbaseSuccessBlock)success
               failure:(CoinbaseFailureBlock)failure {
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if ([response objectForKey:@"error"] || [response objectForKey:@"errors"]) {
        NSDictionary *userInfo;
        if ([response objectForKey:@"error"]) {
            userInfo = @{ @"error": [response objectForKey:@"error"] };
        } else {
            userInfo = @{ @"errors": [response objectForKey:@"errors"] };
        }
        error = [NSError errorWithDomain:CoinbaseErrorDomain code:CoinbaseServerErrorWithMessage userInfo:userInfo];
    } else if ([operation statusCode] >= 300) {
        if (response == nil) {
            response = @{};
        }
        NSDictionary *userInfo = @{ @"statusCode": [NSNumber numberWithInteger: [operation statusCode]], @"response": response };
        error = [NSError errorWithDomain:CoinbaseErrorDomain code:CoinbaseServerErrorWithMessage userInfo:userInfo];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            failure(error);
        } else {
            success(response);
        }
    });
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
    
    NSData *body = nil;
    if (type == CoinbaseRequestTypeGet || type == CoinbaseRequestTypeDelete) {
        // Parameters need to be appended to URL
        NSMutableArray *parts = [NSMutableArray array];
        NSString *encodedKey, *encodedValue;
        for (NSString *key in parameters) {
            encodedKey = [Coinbase URLEncodedStringFromString:key];
            encodedValue = [Coinbase URLEncodedStringFromString:[parameters objectForKey:key]];
            [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
        }
        if (parts.count > 0) {
            path = [path stringByAppendingString:@"?"];
            path = [path stringByAppendingString:[parts componentsJoinedByString:@"&"]];
        }
    } else if (parameters) {
        // POST body is encoded as JSON
        NSError *error = nil;
        body = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        if (error) {
            failure(error);
            return;
        }
    }

    NSURL *baseURL = [NSURL URLWithString:@"https://coinbase.com/api/v1/"];
    NSURL *URL = [NSURL URLWithString:path relativeToURL:baseURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    if (body) {
        [request setHTTPBody:body];
    }
    switch (type) {
        case CoinbaseRequestTypeGet:
            [request setHTTPMethod:@"GET"];
            break;
        case CoinbaseRequestTypePost:
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            break;
        case CoinbaseRequestTypeDelete:
            [request setHTTPMethod:@"DELETE"];
            break;
        case CoinbaseRequestTypePut:
            [request setHTTPMethod:@"PUT"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task;
    task = [session dataTaskWithRequest:request
                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                         if (error) {
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 failure(error);
                             });
                             return;
                         }
                         [self requestSuccess:(NSHTTPURLResponse*)response response:data success:success failure:failure];
                     }];
    [task resume];
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

+ (NSString *)URLEncodedStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@end

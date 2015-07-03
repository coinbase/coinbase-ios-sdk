#import "Coinbase.h"
#import <CommonCrypto/CommonHMAC.h>
#import "CoinbaseAccount.h"
#import "CoinbaseAccountChange.h"
#import "CoinbaseAddress.h"
#import "CoinbaseAuthorization.h"
#import "CoinbaseApplication.h"
#import "CoinbaseButton.h"
#import "CoinbaseContact.h"
#import "CoinbaseCurrency.h"
#import "CoinbaseOrder.h"
#import "CoinbaseRecurringPayment.h"
#import "CoinbaseRefund.h"
#import "CoinbaseReport.h"
#import "CoinbaseTransaction.h"
#import "CoinbaseTransfer.h"
#import "CoinbaseUser.h"
#import "CoinbaseToken.h"
#import "CoinbaseInternal.h"

#import "CoinbasePagingHelper.h"

typedef NS_ENUM(NSUInteger, CoinbaseAuthenticationType) {
    CoinbaseAuthenticationTypeAPIKey,
    CoinbaseAuthenticationTypeOAuth,
    CoinbaseAuthenticationTypeNone
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

// equivalent to [Coinbase new]
+ (Coinbase *)unauthenticatedCoinbase {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.authenticationType = CoinbaseAuthenticationTypeNone;
    }
    return self;
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
            completion:(CoinbaseCompletionBlock)completion {
    NSError *error = nil;
    id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (response == nil) {
        response = @{};
    }

    // Check for errors
    NSMutableDictionary *errorUserInfo = [@{ @"statusCode": [NSNumber numberWithInteger: [operation statusCode]], @"response": response } mutableCopy];
    if ([response isKindOfClass:[NSDictionary class]] && ([response objectForKey:@"error"] || [response objectForKey:@"errors"])) {
        if ([response objectForKey:@"error"]) {
            errorUserInfo[@"errors"] = @[ [response objectForKey:@"error"] ];
        } else {
            errorUserInfo[@"errors"] = [response objectForKey:@"errors"];
        }
        error = [NSError errorWithDomain:CoinbaseErrorDomain code:CoinbaseServerErrorWithMessage userInfo:errorUserInfo];
    } else if ([operation statusCode] >= 300) {
        error = [NSError errorWithDomain:CoinbaseErrorDomain code:CoinbaseServerErrorWithMessage userInfo:errorUserInfo];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        completion(response, error);
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

- (void)doGet:(NSString *)path
   parameters:(NSDictionary *)parameters
   completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters completion:completion];
}

- (void)doPost:(NSString *)path
    parameters:(NSDictionary *)parameters
    completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypePost path:path parameters:parameters completion:completion];
}

- (void)doPut:(NSString *)path
   parameters:(NSDictionary *)parameters
   completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypePut path:path parameters:parameters completion:completion];
}

- (void)doDelete:(NSString *)path
      parameters:(NSDictionary *)parameters
      completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypeDelete path:path parameters:parameters completion:completion];
}

- (void)doGet:(NSString *)path
   parameters:(NSDictionary *)parameters
      headers:(NSDictionary *)headers
   completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:headers completion:completion];
}

- (void)doPost:(NSString *)path
    parameters:(NSDictionary *)parameters
       headers:(NSDictionary *)headers
    completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypePost path:path parameters:parameters headers:headers completion:completion];
}

- (void)doPut:(NSString *)path
   parameters:(NSDictionary *)parameters
      headers:(NSDictionary *)headers
   completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:headers completion:completion];
}

- (void)doDelete:(NSString *)path
      parameters:(NSDictionary *)parameters
         headers:(NSDictionary *)headers
      completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:CoinbaseRequestTypeDelete path:path parameters:parameters headers:headers completion:completion];
}

- (void)doPostMultipart:(NSString *)path
             parameters:(NSDictionary *)parameters
             completion:(CoinbaseCompletionBlock)completion
{
    [self doRequestType:CoinbaseRequestTypePostMultiPart path:path parameters:parameters completion:completion];
}

- (void)doPostMultipart:(NSString *)path
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
           completion:(CoinbaseCompletionBlock)completion
{
    [self doRequestType:CoinbaseRequestTypePostMultiPart path:path parameters:parameters headers:headers completion:completion];
}

- (void)doRequestType:(CoinbaseRequestType)type
                 path:(NSString *)path
           parameters:(NSDictionary *)parameters
           completion:(CoinbaseCompletionBlock)completion {
    [self doRequestType:type path:path parameters:parameters headers:nil completion:completion];
}

- (void)doRequestType:(CoinbaseRequestType)type
                 path:(NSString *)path
           parameters:(NSDictionary *)parameters
              headers:(NSDictionary *)headers
           completion:(CoinbaseCompletionBlock)completion {

    NSMutableData *body = nil;
    NSString *kBoundaryConstant = [NSString stringWithFormat:@"----------%@", [[NSProcessInfo processInfo] globallyUniqueString]];

    if (type == CoinbaseRequestTypeGet || type == CoinbaseRequestTypeDelete) {
        // Parameters need to be appended to URL
        NSMutableArray *parts = [NSMutableArray array];
        NSString *encodedKey, *encodedValue;

        for (NSString *key in parameters) {

            if ([[parameters objectForKey:key] isKindOfClass:[NSDictionary class]])
            {
                for (NSString *nestedKey in [parameters objectForKey:key])
                {
                    encodedValue = [Coinbase URLEncodedStringFromString:[[parameters objectForKey:key] objectForKey:nestedKey]];
                    encodedKey = [NSString stringWithFormat:@"%@[%@]", key, [Coinbase URLEncodedStringFromString:nestedKey]];
                    [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
                }
            }
            else
            {
                encodedKey = [Coinbase URLEncodedStringFromString:key];
                encodedValue = [Coinbase URLEncodedStringFromString:[parameters objectForKey:key]];
                [parts addObject:[NSString stringWithFormat:@"%@=%@", encodedKey, encodedValue]];
            }


        }
        if (parts.count > 0) {
            path = [path stringByAppendingString:@"?"];
            path = [path stringByAppendingString:[parts componentsJoinedByString:@"&"]];
        }
    }
    else if (type == CoinbaseRequestTypePostMultiPart) {

        body = [NSMutableData data];

        for (NSString *param in parameters) {
            if ([[parameters objectForKey:param] isKindOfClass:[NSString class]]) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"%@\r\n", [parameters objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            else if ([[parameters objectForKey:param] isKindOfClass:[UIImage class]]) {
                NSData *imageData = UIImagePNGRepresentation([parameters objectForKey:param]);
                if (imageData) {
                    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", kBoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                    [body appendData:imageData];
                    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
                }
            }
        }

        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else if (parameters) {
        // POST body is encoded as JSON
        NSError *error = nil;
        body = (NSMutableData*)[NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
        if (error) {
            completion(nil, error);
            return;
        }
    }

    NSURL *baseURL = [NSURL URLWithString:@"v1/" relativeToURL:(self.baseURL == nil ? [NSURL URLWithString:@"https://api.coinbase.com/"] : self.baseURL)];
    NSURL *URL = [[NSURL URLWithString:path relativeToURL:baseURL] absoluteURL];
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
        case CoinbaseRequestTypePostMultiPart:
            [request setHTTPMethod:@"POST"];
            [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", kBoundaryConstant] forHTTPHeaderField:@"Content-Type"];

            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            break;
    }

    if (self.authenticationType == CoinbaseAuthenticationTypeAPIKey) {
        // HMAC auth
        NSInteger nonce = [[NSDate date] timeIntervalSince1970] * 100000;
        NSString *toBeSigned = [NSString stringWithFormat:@"%ld%@%@", (long)nonce, [URL absoluteString], body ? [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding] : @""];
        NSString *signature = [self generateSignature: toBeSigned];
        [request setValue:self.apiKey forHTTPHeaderField:@"ACCESS_KEY"];
        [request setValue:signature forHTTPHeaderField:@"ACCESS_SIGNATURE"];
        [request setValue:[NSString stringWithFormat:@"%ld", (long)nonce] forHTTPHeaderField:@"ACCESS_NONCE"];
    } else if (self.authenticationType == CoinbaseAuthenticationTypeOAuth) {
        // OAuth
        [request setValue:[NSString stringWithFormat:@"Bearer %@", self.accessToken] forHTTPHeaderField:@"Authorization"];
    }

    if (headers != nil) {
        for (NSString *header in [headers keyEnumerator]) {
            [request setValue:headers[header] forHTTPHeaderField:header];
        }
    }

    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task;
    task = [session dataTaskWithRequest:request
                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          if (error) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  completion(nil, error);
                              });
                              return;
                          }
                          [self requestSuccess:(NSHTTPURLResponse*)response response:data completion: completion];
                      }];
    [task resume];
}

#pragma mark - Accounts

-(void) getAccountsList:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"accounts" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseAccounts = [response objectForKey:@"accounts"];

            NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:responseAccounts.count];

            for (NSDictionary *dictionary in responseAccounts)
            {
                CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:dictionary];
                [accounts addObject:account];
            }

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(accounts, pagingHelper, error);
        }
    }];
}

-(void) getAccountsListWithPage:(NSUInteger)page
                          limit:(NSUInteger)limit
                    allAccounts:(BOOL)allAccounts
                     completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"all_accounts" : allAccounts ? @"true" : @"false",
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseAccounts = [response objectForKey:@"accounts"];

            NSMutableArray *accounts = [[NSMutableArray alloc] initWithCapacity:responseAccounts.count];

            for (NSDictionary *dictionary in responseAccounts)
            {
                CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:dictionary];
                [accounts addObject:account];
            }

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(accounts, pagingHelper, error);
        }
    }];
}

-(void) getAccount:(NSString *)accountID completion:(void(^)(CoinbaseAccount*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", accountID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(account , error);
        }
    }];
}

-(void) getPrimaryAccount:(void(^)(CoinbaseAccount*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"accounts/primary" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(account , error);
        }
    }];
}

-(void) createAccountWithName:(NSString *)name
                   completion:(void(^)(CoinbaseAccount*, NSError*))callback
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : name}};

    [self doRequestType:CoinbaseRequestTypePost path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(account , error);
        }
    }];
}

-(void) deleteAccount:(NSString *)accountID completion:(void(^)(BOOL, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", accountID];

    [self doRequestType:CoinbaseRequestTypeDelete path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];

            callback(success, error);
        }
    }];
}

#pragma mark - Addresses

-(void) getAddressWithAddressOrID:(NSString *)addressOrID completion:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"addresses/%@", addressOrID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[response objectForKey:@"address"]];
            callback(address, error);
        }
    }];
}

-(void) getAddressWithAddressOrID:(NSString *)addressOrID
                        accountId:(NSString *)accountId
                       completion:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"addresses/%@", addressOrID];

    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountId),
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[response objectForKey:@"address"]];
            callback(address, error);
        }
    }];
}

-(void) createBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypePost path:@"addresses" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];
            callback(address , error);
        }
    }];
}

-(void) createBitcoinAddressWithAccountID:(NSString*)accountID
                                    label:(NSString*)label
                              callBackURL:(NSString *)callBackURL
                               competiton:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSDictionary *parameters = @{@"address" :
                                    @{@"label" : ObjectOrEmptyString(label),
                                      @"callback_url" : ObjectOrEmptyString(callBackURL)}};

    [self doRequestType:CoinbaseRequestTypePost path:@"addresses" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];
            callback(address , error);
        }
    }];
}

#pragma mark - Authorization

-(void) getAuthorizationInformation:(void(^)(CoinbaseAuthorization*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"authorization" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAuthorization *authorization = [[CoinbaseAuthorization alloc] initWithDictionary:response];
            callback(authorization, error);
        }
    }];
}

#pragma mark - Button

-(void) createButtonWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(void(^)(CoinbaseButton*, NSError*))callback
{
    NSDictionary *parameters = @{@"button" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"price_string": ObjectOrEmptyString(price),
                                       @"price_currency_iso" : ObjectOrEmptyString(priceCurrencyISO)
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"buttons" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseButton *button = [[CoinbaseButton alloc] initWithDictionary:[response objectForKey:@"button"]];
            callback(button, error);
        }
    }];
}

-(void) createButtonWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                  accountID:(NSString *)accountID
                       type:(NSString *)type
               subscription:(BOOL)subscription
                     repeat:(NSString *)repeat
                      style:(NSString *)style
                       text:(NSString *)text
                description:(NSString *)description
                     custom:(NSString *)custom
               customSecure:(BOOL)customSecure
                callbackURL:(NSString *)callbackURL
                 successURL:(NSString *)successURL
                  cancelURL:(NSString *)cancelURL
                    infoURL:(NSString *)infoURL
               autoRedirect:(BOOL)autoRedirect
        autoRedirectSuccess:(BOOL)autoRedirectSuccess
         autoRedirectCancel:(BOOL)autoRedirectCancel
              variablePrice:(BOOL)variablePrice
             includeAddress:(BOOL)includeAddress
               includeEmail:(BOOL)includeEmail
                choosePrice:(BOOL)choosePrice
                     price1:(NSString *)price1
                     price2:(NSString *)price2
                     price3:(NSString *)price3
                     price4:(NSString *)price4
                     price5:(NSString *)price5
                 completion:(void(^)(CoinbaseButton*, NSError*))callback
{
    NSDictionary *parameters = @{@"button" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"price_string": ObjectOrEmptyString(price),
                                       @"price_currency_iso" : ObjectOrEmptyString(priceCurrencyISO),
                                       @"account_id" : ObjectOrEmptyString(accountID),
                                       @"type" : ObjectOrEmptyString(type),
                                       @"subscription" : subscription ? @"true" : @"false",
                                       @"repeat" : ObjectOrEmptyString(repeat),
                                       @"style" : ObjectOrEmptyString(style),
                                       @"text" : ObjectOrEmptyString(text),
                                       @"description" : ObjectOrEmptyString(description),
                                       @"custom" : ObjectOrEmptyString(custom),
                                       @"custom_secure" : customSecure ? @"true" : @"false",
                                       @"callback_url" : ObjectOrEmptyString(callbackURL),
                                       @"success_url" : ObjectOrEmptyString(successURL),
                                       @"cancel_url" : ObjectOrEmptyString(cancelURL),
                                       @"info_url" : ObjectOrEmptyString(infoURL),
                                       @"auto_redirect" : autoRedirect ? @"true" : @"false",
                                       @"auto_redirect_success" : autoRedirectSuccess ? @"true" : @"false",
                                       @"auto_redirect_cancel" : autoRedirectCancel ? @"true" : @"false",
                                       @"variable_price" : variablePrice ? @"true" : @"false",
                                       @"include_address" : includeAddress ? @"true" : @"false",
                                       @"include_email" : includeEmail ? @"true" : @"false",
                                       @"choose_price" : choosePrice ? @"true" : @"false",
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"buttons" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseButton *button = [[CoinbaseButton alloc] initWithDictionary:[response objectForKey:@"button"]];
            callback(button, error);
        }
    }];
}

-(void)getButtonWithID:(NSString *)customValueOrID completion:(void(^)(CoinbaseButton*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"buttons/%@", customValueOrID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseButton *button = [[CoinbaseButton alloc] initWithDictionary:[response objectForKey:@"button"]];
            callback(button, error);
        }
    }];
}

-(void) createOrderForButtonWithID:(NSString *)customValueOrID completion:(void(^)(CoinbaseOrder*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"buttons/%@/create_order", customValueOrID];

    [self doRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

#pragma mark - Buys

-(void) buy:(NSString *)quantity completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity)
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"buys" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

-(void)                 buy:(NSString *)quantity
                  accountID:(NSString *)accountID
                   currency:(NSString *)currency
       agreeBTCAmountVaries:(BOOL)agreeBTCAmountVaries
                     commit:(BOOL)commit
            paymentMethodID:(NSString *)paymentMethodID
                 completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity),
                                 @"account_id" : ObjectOrEmptyString(accountID),
                                 @"currency" : ObjectOrEmptyString(currency),
                                 @"agree_btc_amount_varies" : agreeBTCAmountVaries ? @"true" : @"false",
                                 @"commit" : commit ? @"true" : @"false",
                                 @"paymentMethodID" : ObjectOrEmptyString(paymentMethodID)
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"buys" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

#pragma mark - Contacts


-(void) getContacts:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"contacts" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseContacts = [response objectForKey:@"contacts"];

            NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:responseContacts.count];

            for (NSDictionary *dictionary in responseContacts)
            {
                CoinbaseContact *contact = [[CoinbaseContact alloc] initWithDictionary:[dictionary objectForKey:@"contact"]];
                [contacts addObject:contact];
            }

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(contacts, pagingHelper, error);
        }
    }];
}

-(void) getContactsWithPage:(NSUInteger)page
                      limit:(NSUInteger)limit
                      query:(NSString *)query
                 completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"query" : ObjectOrEmptyString(query),
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"contacts" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseContacts = [response objectForKey:@"contacts"];

            NSMutableArray *contacts = [[NSMutableArray alloc] initWithCapacity:responseContacts.count];

            for (NSDictionary *dictionary in responseContacts)
            {
                CoinbaseContact *contact = [[CoinbaseContact alloc] initWithDictionary:[dictionary objectForKey:@"contact"]];
                [contacts addObject:contact];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(contacts, pagingHelper, error);
        }
    }];
}

#pragma mark - Currencies

-(void) getSupportedCurrencies:(void(^)(NSArray*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"currencies" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSArray class]])
        {
            NSMutableArray *currencies = [[NSMutableArray alloc] init];

            for (NSArray *array in response)
            {
                CoinbaseCurrency *currency = [[CoinbaseCurrency alloc] initWithArray:array];
                [currencies addObject:currency];
            }
            callback(currencies, error);
        }
    }];
}

-(void) getExchangeRates:(void(^)(NSDictionary*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"currencies/exchange_rates" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            callback(response, error);
        }
    }];
}

#pragma mark - Multisig

-(void) createMultiSigAccountWithName:(NSString *)name
                                 type:(NSString *)type
                   requiredSignatures:(NSUInteger)requiredSignatures
                             xPubKeys:(NSArray *)xPubKeys
                           completion:(void(^)(CoinbaseAccount*, NSError*))callback;
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"type": ObjectOrEmptyString(type),
                                       @"m" : [[NSNumber numberWithUnsignedInteger:requiredSignatures] stringValue],
                                       @"xpubkeys": xPubKeys}
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(account , error);
        }
    }];
}

#pragma mark - OAuth Applications


-(void) getOAuthApplications:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"oauth/applications" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseApplications = [response objectForKey:@"applications"];

            NSMutableArray *applications = [[NSMutableArray alloc] initWithCapacity:responseApplications.count];

            for (NSDictionary *dictionary in responseApplications)
            {
                CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:dictionary];
                [applications addObject:application];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(applications, pagingHelper, error);
        }
    }];
}

-(void) getOAuthApplicationsWithPage:(NSUInteger)page
                               limit:(NSUInteger)limit
                          completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"oauth/applications" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseApplications = [response objectForKey:@"applications"];

            NSMutableArray *applications = [[NSMutableArray alloc] initWithCapacity:responseApplications.count];

            for (NSDictionary *dictionary in responseApplications)
            {
                CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:dictionary];
                [applications addObject:application];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(applications, pagingHelper, error);
        }
    }];
}

-(void) getOAuthApplicationWithID:(NSString *)applicationID
                       completion:(void(^)(CoinbaseApplication*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"oauth/applications/%@", applicationID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:[response objectForKey:@"application"]];

            callback(application, error);
        }
    }];
}

-(void) createOAuthApplicationWithName:(NSString *)name
                           reDirectURL:(NSString *)reDirectURL
                            completion:(void(^)(CoinbaseApplication*, NSError*))callback;
{
    NSDictionary *parameters = @{@"application" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"redirect_uri": ObjectOrEmptyString(reDirectURL)
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"oauth/applications" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:[response objectForKey:@"application"]];

            callback(application, error);
        }
    }];
}

#pragma mark - Orders

-(void) getOrders:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"orders" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseOrders = [response objectForKey:@"orders"];

            NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:responseOrders.count];

            for (NSDictionary *dictionary in responseOrders)
            {
                CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[dictionary objectForKey:@"order"]];
                [orders addObject:order];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(orders, pagingHelper, error);
        }
    }];
}

-(void) getOrdersWithPage:(NSUInteger)page
                    limit:(NSUInteger)limit
                accountID:(NSString *)accountID
               completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"orders" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseOrders = [response objectForKey:@"orders"];

            NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:responseOrders.count];

            for (NSDictionary *dictionary in responseOrders)
            {
                CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[dictionary objectForKey:@"order"]];
                [orders addObject:order];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(orders, pagingHelper, error);
        }
    }];
}

-(void) createOrderWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(void(^)(CoinbaseOrder*, NSError*))callback
{
    NSDictionary *parameters = @{@"button" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"price_string": ObjectOrEmptyString(price),
                                       @"price_currency_iso" : ObjectOrEmptyString(priceCurrencyISO)
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"orders" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

-(void) createOrderWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                  accountID:(NSString *)accountID
                       type:(NSString *)type
               subscription:(BOOL)subscription
                     repeat:(NSString *)repeat
                      style:(NSString *)style
                       text:(NSString *)text
                description:(NSString *)description
                     custom:(NSString *)custom
               customSecure:(BOOL)customSecure
                callbackURL:(NSString *)callbackURL
                 successURL:(NSString *)successURL
                  cancelURL:(NSString *)cancelURL
                    infoURL:(NSString *)infoURL
               autoRedirect:(BOOL)autoRedirect
        autoRedirectSuccess:(BOOL)autoRedirectSuccess
         autoRedirectCancel:(BOOL)autoRedirectCancel
              variablePrice:(BOOL)variablePrice
             includeAddress:(BOOL)includeAddress
               includeEmail:(BOOL)includeEmail
                choosePrice:(BOOL)choosePrice
                     price1:(NSString *)price1
                     price2:(NSString *)price2
                     price3:(NSString *)price3
                     price4:(NSString *)price4
                     price5:(NSString *)price5
                 completion:(void(^)(CoinbaseOrder*, NSError*))callback
{
    NSDictionary *parameters = @{@"button" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"price_string": ObjectOrEmptyString(price),
                                       @"price_currency_iso" : ObjectOrEmptyString(priceCurrencyISO),
                                       @"account_id" : ObjectOrEmptyString(accountID),
                                       @"type" : ObjectOrEmptyString(type),
                                       @"subscription" : subscription ? @"true" : @"false",
                                       @"repeat" : ObjectOrEmptyString(repeat),
                                       @"style" : ObjectOrEmptyString(style),
                                       @"text" : ObjectOrEmptyString(text),
                                       @"description" : ObjectOrEmptyString(description),
                                       @"custom" : ObjectOrEmptyString(custom),
                                       @"custom_secure" : customSecure ? @"true" : @"false",
                                       @"callback_url" : ObjectOrEmptyString(callbackURL),
                                       @"success_url" : ObjectOrEmptyString(successURL),
                                       @"cancel_url" : ObjectOrEmptyString(cancelURL),
                                       @"info_url" : ObjectOrEmptyString(infoURL),
                                       @"auto_redirect" : autoRedirect ? @"true" : @"false",
                                       @"auto_redirect_success" : autoRedirectSuccess ? @"true" : @"false",
                                       @"auto_redirect_cancel" : autoRedirectCancel ? @"true" : @"false",
                                       @"variable_price" : variablePrice ? @"true" : @"false",
                                       @"include_address" : includeAddress ? @"true" : @"false",
                                       @"include_email" : includeEmail ? @"true" : @"false",
                                       @"choose_price" : choosePrice ? @"true" : @"false",
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"orders" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

-(void) getOrderWithID:(NSString *)customFieldOrID
            completion:(void(^)(CoinbaseOrder*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"orders/%@", customFieldOrID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

-(void) getOrderWithID:(NSString *)customFieldOrID
             accountID:(NSString *)accountID
            completion:(void(^)(CoinbaseOrder*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"orders/%@", customFieldOrID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

#pragma mark - Payment Methods

-(void) getPaymentMethods:(void(^)(NSArray*, NSString*, NSString*, NSError*))callback;
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"payment_methods" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSString *defaultBuy = [response objectForKey:@"default_buy"];
            NSString *defaultSell = [response objectForKey:@"default_sell"];

            NSArray *responsePaymentMethods = [response objectForKey:@"payment_methods"];

            NSMutableArray *paymentMethods = [[NSMutableArray alloc] initWithCapacity:responsePaymentMethods.count];

            for (NSDictionary *dictionary in responsePaymentMethods)
            {
                CoinbasePaymentMethod *paymentMethod = [[CoinbasePaymentMethod alloc] initWithDictionary:[dictionary objectForKey:@"payment_method"]];
                [paymentMethods addObject:paymentMethod];
            }

            callback(paymentMethods, defaultBuy, defaultSell, error);
        }
    }];
}

-(void) paymentMethodWithID:(NSString *)paymentMethodID completion:(void(^)(CoinbasePaymentMethod*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"payment_methods/%@", paymentMethodID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbasePaymentMethod *paymentMethod = [[CoinbasePaymentMethod alloc] initWithDictionary:[response objectForKey:@"payment_method"]];
            callback(paymentMethod, error);
        }
    }];
}

#pragma mark - Prices

-(void) getBuyPrice:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/buy" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
            NSArray *fees = [response objectForKey:@"fees"];
            CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
            CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];

            callback(btc, fees, subtotal, total, error);
        }
    }];
}

-(void) getBuyPriceWithQuantity:(NSString *)quantity
                       currency:(NSString *)currency
                     completion:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity),
                                 @"currency" : ObjectOrEmptyString(currency)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/buy" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
            NSArray *fees = [response objectForKey:@"fees"];
            CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
            CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];

            callback(btc, fees, subtotal, total, error);
        }
    }];
}

-(void) getSellPrice:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/sell" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
            NSArray *fees = [response objectForKey:@"fees"];
            CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
            CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];

            callback(btc, fees, subtotal, total, error);
        }
    }];
}

-(void) getSellPriceWithQuantity:(NSString *)quantity
                        currency:(NSString *)currency
                      completion:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity),
                                 @"currency" : ObjectOrEmptyString(currency)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/sell" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
            NSArray *fees = [response objectForKey:@"fees"];
            CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
            CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];

            callback(btc, fees, subtotal, total, error);
        }
    }];
}

-(void) getSpotRate:(void(^)(CoinbaseBalance*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/spot_rate" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];
            callback(balance, error);
        }
    }];
}

-(void) getSpotRateWithCurrency:(NSString *)currency
                     completion:(void(^)(CoinbaseBalance*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"currency" : ObjectOrEmptyString(currency)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/spot_rate" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];
            callback(balance, error);
        }
    }];
}

-(void) getHistoricalSpotRate:(CoinbaseCompletionBlock)completion
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/historical" parameters:nil headers:nil completion:completion];
}

-(void) getHistoricalSpotRateWithPage:(NSUInteger)page
                           completion:(CoinbaseCompletionBlock)completion
{
    NSDictionary *parameters = @{
                                 @"page" : [NSNumber numberWithUnsignedInteger:page]
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"prices/historical" parameters:parameters headers:nil completion:completion];
}

#pragma mark - Recurring Payments

-(void) getRecurringPayments:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"recurring_payments" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

            NSMutableArray *recurringPayments = [[NSMutableArray alloc] initWithCapacity:responseRecurringPayments.count];

            for (NSDictionary *dictionary in responseRecurringPayments)
            {
                CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
                [recurringPayments addObject:recurringPayment];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(recurringPayments, pagingHelper, error);
        }
    }];
}

-(void) getRecurringPaymentsWithPage:(NSUInteger)page
                               limit:(NSUInteger)limit
                          completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue]
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"recurring_payments" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

            NSMutableArray *recurringPayments = [[NSMutableArray alloc] initWithCapacity:responseRecurringPayments.count];

            for (NSDictionary *dictionary in recurringPayments)
            {
                CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
                [recurringPayments addObject:recurringPayment];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(recurringPayments, pagingHelper, error);
        }
    }];
}

-(void) recurringPaymentWithID:(NSString *)recurringPaymentID
                    completion:(void(^)(CoinbaseRecurringPayment*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"recurring_payments/%@", recurringPaymentID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[response objectForKey:@"recurring_payment"]];
            callback(recurringPayment, error);
        }
    }];
}

#pragma mark - Refunds

-(void) refundWithID:(NSString *)refundID
          completion:(void(^)(CoinbaseRefund*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"refunds/%@", refundID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseRefund *refund = [[CoinbaseRefund alloc] initWithDictionary:[response objectForKey:@"refund"]];
            callback(refund, error);
        }
    }];
}

#pragma mark - Reports

-(void) getReports:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"reports" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseReports = [response objectForKey:@"reports"];

            NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:responseReports.count];

            for (NSDictionary *dictionary in responseReports)
            {
                CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[dictionary objectForKey:@"report"]];
                [reports addObject:report];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(reports, pagingHelper, error);
        }
    }];
}

-(void) getReportsWithPage:(NSUInteger)page
                     limit:(NSUInteger)limit
                completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"reports" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseReports = [response objectForKey:@"reports"];

            NSMutableArray *reports = [[NSMutableArray alloc] initWithCapacity:responseReports.count];

            for (NSDictionary *dictionary in responseReports)
            {
                CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[dictionary objectForKey:@"report"]];
                [reports addObject:report];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(reports, pagingHelper, error);
        }
    }];
}

-(void) reportWithID:(NSString *)reportID completion:(void(^)(CoinbaseReport*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"reports/%@", reportID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[response objectForKey:@"report"]];
            callback(report, error);
        }
    }];
}

-(void) createReportWithType:(NSString *)type
                       email:(NSString *)email
                  completion:(void(^)(CoinbaseReport*, NSError*))callback
{
    NSDictionary *parameters = @{@"report" :
                                     @{@"type" : ObjectOrEmptyString(type),
                                       @"email": ObjectOrEmptyString(email),
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"reports" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[response objectForKey:@"report"]];
            callback(report, error);
        }
    }];
}

-(void) createReportWithType:(NSString *)type
                       email:(NSString *)email
                   accountID:(NSString *)accountID
                 callbackURL:(NSString *)callbackURL
                   timeRange:(NSString *)timeRange
              timeRangeStart:(NSString *)timeRangeStart
                timeRangeEnd:(NSString *)timeRangeEnd
                   startType:(NSString *)startType
                 nextRunDate:(NSString *)nextRunDate
                 nextRunTime:(NSString *)nextRunTime
                      repeat:(NSString *)repeat
                       times:(NSUInteger)times
                  completion:(void(^)(CoinbaseReport*, NSError*))callback
{
    NSDictionary *parameters = @{@"report" :
                                     @{@"type" : ObjectOrEmptyString(type),
                                       @"email": ObjectOrEmptyString(email),
                                       @"callback_url": ObjectOrEmptyString(callbackURL),
                                       @"time_range": ObjectOrEmptyString(timeRange),
                                       @"time_range_start": ObjectOrEmptyString(timeRangeStart),
                                       @"time_range_end": ObjectOrEmptyString(timeRangeEnd),
                                       @"start_type": ObjectOrEmptyString(startType),
                                       @"next_run_date": ObjectOrEmptyString(nextRunDate),
                                       @"next_run_time": ObjectOrEmptyString(nextRunTime),
                                       @"repeat": ObjectOrEmptyString(repeat),
                                       @"times": [NSNumber numberWithUnsignedInteger:times]
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"reports" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[response objectForKey:@"report"]];
            callback(report, error);
        }
    }];
}

#pragma mark - Sells

-(void) sellQuantity:(NSString *)quantity
          completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity)
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"sells" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

-(void) sellQuantity:(NSString *)quantity
           accountID:(NSString *)accountID
            currency:(NSString *)currency
              commit:(BOOL)commit
agreeBTCAmountVaries:(BOOL)agreeBTCAmountVaries
     paymentMethodID:(NSString *)paymentMethodID
          completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"qty" : ObjectOrEmptyString(quantity),
                                 @"account_id" : ObjectOrEmptyString(accountID),
                                 @"currency" : ObjectOrEmptyString(currency),
                                 @"commit" : commit ? @"true" : @"false",
                                 @"agree_btc_amount_varies" : agreeBTCAmountVaries ? @"true" : @"false",
                                 @"payment_method_id" : ObjectOrEmptyString(paymentMethodID)
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"sells" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

#pragma mark - Subscribers

-(void) getSubscribers:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"subscribers" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil,error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

            NSMutableArray *recurringPayments = [[NSMutableArray alloc] initWithCapacity:responseRecurringPayments.count];

            for (NSDictionary *dictionary in responseRecurringPayments)
            {
                CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
                [recurringPayments addObject:recurringPayment];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(recurringPayments, pagingHelper, error);
        }
    }];
}

-(void) getSubscribersWithAccountID:(NSString *)accountID
                         completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"subscribers" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

            NSMutableArray *recurringPayments = [[NSMutableArray alloc] initWithCapacity:responseRecurringPayments.count];

            for (NSDictionary *dictionary in recurringPayments)
            {
                CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
                [recurringPayments addObject:recurringPayment];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(recurringPayments, pagingHelper, error);
        }
    }];
}

-(void) subscriptionWithID:(NSString *)subscriptionID completion:(void(^)(CoinbaseRecurringPayment*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"subscribers/%@", subscriptionID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[response objectForKey:@"recurring_payment"]];
            callback(recurringPayment, error);
        }
    }];
}

-(void) subscriptionWithID:(NSString *)subscriptionID
                 accountID:(NSString *)accountID
                completion:(void(^)(CoinbaseRecurringPayment*, NSError*))callback;
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };
    NSString *path = [NSString stringWithFormat:@"subscribers/%@", subscriptionID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[response objectForKey:@"recurring_payment"]];
            callback(recurringPayment, error);
        }
    }];
}

#pragma mark - Tokens

-(void) createToken:(void(^)(CoinbaseToken *, NSError*))callback;
{
    [self doRequestType:CoinbaseRequestTypePost path:@"tokens" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseToken *token = [[CoinbaseToken alloc] initWithDictionary:[response objectForKey:@"token"]];
            callback(token, error);
        }
    }];
}

-(void) redeemTokenWithID:(NSString *)tokenID completion:(void(^)(BOOL, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"token_id" : ObjectOrEmptyString(tokenID)
                                 };

    [self doRequestType:CoinbaseRequestTypePost path:@"tokens/redeem" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];
            callback(success, error);
        }
    }];
}

#pragma mark - Transactions

-(void) getTransactions:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"transactions" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
            CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];

            NSArray *responseTransactions = [response objectForKey:@"transactions"];

            NSMutableArray *transactions = [[NSMutableArray alloc] initWithCapacity:responseTransactions.count];

            for (NSDictionary *dictionary in responseTransactions)
            {
                CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[dictionary objectForKey:@"transaction"]];
                [transactions addObject:transaction];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(transactions, user, balance, nativeBalance, pagingHelper, error);
        }
    }];
}

-(void) getTransactionsWithPage:(NSUInteger)page
                          limit:(NSUInteger)limit
                      accountID:(NSString *)accountID
                     completion:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"transactions" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
            CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];

            NSArray *responseTransactions = [response objectForKey:@"transactions"];

            NSMutableArray *transactions = [[NSMutableArray alloc] initWithCapacity:responseTransactions.count];

            for (NSDictionary *dictionary in responseTransactions)
            {
                CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:dictionary];
                [transactions addObject:transaction];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(transactions, user, balance, nativeBalance, pagingHelper, error);
        }
    }];
}

-(void) transactionWithID:(NSString *)transactionID
               completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@", transactionID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) transactionWithID:(NSString *)transactionID
                accountID:(NSString *)accountID
               completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transactions/%@", transactionID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

#pragma mark - Transfers

-(void) getTransfers:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"transfers" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseTransfers = [response objectForKey:@"transfers"];

            NSMutableArray *transfers = [[NSMutableArray alloc] initWithCapacity:responseTransfers.count];

            for (NSDictionary *dictionary in responseTransfers)
            {
                CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[dictionary objectForKey:@"transfer"]];
                [transfers addObject:transfer];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(transfers, pagingHelper, error);
        }
    }];
}

-(void) getTransfersWithPage:(NSUInteger)page
                       limit:(NSUInteger)limit
                   accountID:(NSString *)accountID
                  completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    [self doRequestType:CoinbaseRequestTypeGet path:@"transfers" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseTransfers = [response objectForKey:@"transfers"];

            NSMutableArray *transfers = [[NSMutableArray alloc] initWithCapacity:responseTransfers.count];

            for (NSDictionary *dictionary in responseTransfers)
            {
                CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:dictionary];
                [transfers addObject:transfer];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(transfers, pagingHelper, error);
        }
    }];
}

-(void) transferWithID:(NSString *)transferID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transfers/%@", transferID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

-(void) transferWithID:(NSString *)transferID
             accountID:(NSString *)accountID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transfers/%@", transferID];

    [self doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

#pragma mark - Users

-(void) getCurrentUser:(void(^)(CoinbaseUser*, NSError*))callback
{
    [self doRequestType:CoinbaseRequestTypeGet path:@"users/self" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
            callback(user , error);
        }
    }];
}

-(void) modifyCurrentUserName:(NSString *)name
                   completion:(void(^)(CoinbaseUser*, NSError*))callback
{
    NSDictionary *parameters = @{@"user" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePut path:@"users/self" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
            callback(user , error);
        }
    }];
}

-(void) modifyCurrentUserNativeCurrency:(NSString *)nativeCurrency
                             completion:(void(^)(CoinbaseUser*, NSError*))callback
{
    NSDictionary *parameters = @{@"user" :
                                     @{@"native_currency" : ObjectOrEmptyString(nativeCurrency),
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePut path:@"users/self" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
            callback(user , error);
        }
    }];
}

-(void) modifyCurrentUserTimeZone:(NSString *)timeZone
                       completion:(void(^)(CoinbaseUser*, NSError*))callback
{
    NSDictionary *parameters = @{@"user" :
                                     @{@"time_zone" : ObjectOrEmptyString(timeZone),
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePut path:@"users/self" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
            callback(user , error);
        }
    }];
}

-(void) modifyCurrentUserName:(NSString *)name
               nativeCurrency:(NSString *)nativeCurrency
                     timeZone:(NSString *)timeZone
                   completion:(void(^)(CoinbaseUser*, NSError*))callback
{
    NSDictionary *parameters = @{@"user" :
                                     @{@"name" : ObjectOrEmptyString(name),
                                       @"native_currency" : ObjectOrEmptyString(nativeCurrency),
                                       @"time_zone" : ObjectOrEmptyString(timeZone)
                                       }
                                 };

    [self doRequestType:CoinbaseRequestTypePut path:@"users/self" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
            callback(user , error);
        }
    }];
}

#pragma mark -

+ (NSString *)URLEncodedStringFromString:(NSString *)string
{
    static CFStringRef charset = CFSTR("!@#$%&*()+'\";:=,/?[] ");
    CFStringRef str = (__bridge CFStringRef)string;
    CFStringEncoding encoding = kCFStringEncodingUTF8;
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, str, NULL, charset, encoding));
}

@end

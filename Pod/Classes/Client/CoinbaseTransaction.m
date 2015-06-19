//
//  CoinbaseTransaction.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseTransaction.h"
#import "CoinbaseInternal.h"

@implementation CoinbaseTransaction

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _transactionID = [dictionary objectForKey:@"id"];
        _hashString = [dictionary objectForKey:@"hash"];
        _hshString = [dictionary objectForKey:@"hsh"];
        _amount = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"amount"]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        _sellLimit = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];
        _request = [[dictionary objectForKey:@"request"] boolValue];
        _status = [dictionary objectForKey:@"status"];
        _sender = [[CoinbaseUser alloc] initWithDictionary:[dictionary objectForKey:@"sender"]];
        _recipient = [[CoinbaseUser alloc] initWithDictionary:[dictionary objectForKey:@"recipient"]];
        _recipientAddress = [dictionary objectForKey:@"recipient_address"];
        _idem = [dictionary objectForKey:@"idem"];
        _notes = [dictionary objectForKey:@"notes"];
        _type = [dictionary objectForKey:@"type"];
        _isSigned = [[dictionary objectForKey:@"signed"] boolValue];
        _signaturesRequired = [[dictionary objectForKey:@"signatures_required"] unsignedIntegerValue];
        _signaturesPresent = [[dictionary objectForKey:@"signatures_present"] unsignedIntegerValue];
        _signaturesNeeded = [[dictionary objectForKey:@"signatures_needed"] unsignedIntegerValue];

        _inputArray = [dictionary objectForKey:@"inputs"];
        _confirmations = [[dictionary objectForKey:@"confirmations"] unsignedIntegerValue];
    }
    return self;
}

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.transactionID = theID;
        self.client = client;
    }
    return self;
}

-(void) getSignatureHashes:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@/sighashes", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction , error);
        }
    }];
}

-(void) getSignatureHashesWithAccountID:(NSString *)accountID
                             completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@/sighashes", _transactionID];

    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID),
                                 };

    [self.client doRequestType:CoinbaseRequestTypeGet path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction , error);
        }
    }];
}

-(void) requiredSignaturesForMultiSig:(NSArray *)signatures
                           completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"signatures": signatures
                                 };

    NSString *path = [NSString stringWithFormat:@"transactions/%@/signatures", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction , error);
        }
    }];
}

-(void) resendRequest:(void(^)(BOOL, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@/resend_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];

            callback(success , error);
        }
    }];
}

-(void) resendRequestWithAccountID:(NSString *)accountID
                        completion:(void(^)(BOOL, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transactions/%@/resend_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];

            callback(success , error);
        }
    }];
}

-(void) completeRequest:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@/complete_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

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

-(void) completeRequestWithAccountID:(NSString *)accountID
                          completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transactions/%@/complete_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

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

-(void) cancelRequest:(void(^)(BOOL, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transactions/%@/cancel_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypeDelete path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];

            callback(success , error);
        }
    }];
}

-(void) cancelRequestWithAccountID:(NSString *)accountID
                        completion:(void(^)(BOOL, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transactions/%@/cancel_request", _transactionID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];
            
            callback(success , error);
        }
    }];
}


@end
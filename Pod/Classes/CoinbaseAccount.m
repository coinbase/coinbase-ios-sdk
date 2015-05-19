//
//  CoinbaseAccount.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbaseAccount.h"

@implementation CoinbaseAccount

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _active = [[dictionary objectForKey:@"active"] boolValue];

        _balance = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _accountID = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];

        _nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"native_balance"]];

        _primary = [[dictionary objectForKey:@"primary"] boolValue];
        _type = [dictionary objectForKey:@"type"];
        _m = [[dictionary objectForKey:@"m"] stringValue];
        _n = [[dictionary objectForKey:@"n"] stringValue];
    }
    
    return self;
}

-(void) getBalance:(void(^)(CoinbaseBalance*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/balance", _accountID];

    [super doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];
            callback(balance , error);
        }
    }];
}

-(void) getBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", _accountID];

    [super doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

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

-(void) modifyWithName:(NSString *)name
                   completion:(void(^)(CoinbaseAccount*, NSError*))callback
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : ObjectOrEmptyString(name)}};

    NSString *path = [NSString stringWithFormat:@"accounts/%@", _accountID];

    [super doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

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

-(void) setAsPrimary:(void(^)(BOOL, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/primary", _accountID];

    [super doRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
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

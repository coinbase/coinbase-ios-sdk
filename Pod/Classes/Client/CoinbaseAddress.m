//
//  CoinbaseAddress.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbaseAddress.h"

@implementation CoinbaseAddress

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _addressID = [dictionary objectForKey:@"id"];
        _address = [dictionary objectForKey:@"address"];
        _callbackURL = [dictionary objectForKey:@"callback_url"];
        _label = [dictionary objectForKey:@"label"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _type = [dictionary objectForKey:@"type"];
        _redeemScript = [dictionary objectForKey:@"redeem_script"];
    }
    return self;
}

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.addressID = theID;
        self.client = client;
    }
    return self;
}

-(void) createBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback
{
    [self.client doRequestType:CoinbaseRequestTypePost path:@"addresses" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(address , error);
        }
    }];
}

-(void) createBitcoinAddressWithAccountID:(NSString*)accountID
                                    label:(NSString *)label
                              callBackURL:(NSString *)callBackURL
                               completion:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSDictionary *parameters = @{@"address" :
                                     @{@"accountID" : accountID,
                                       @"label" : label,
                                       @"callback_url" : callBackURL
                                       }};

    [self.client doRequestType:CoinbaseRequestTypePost path:@"addresses" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response ];
            callback(address , error);
        }
    }];
}

@end

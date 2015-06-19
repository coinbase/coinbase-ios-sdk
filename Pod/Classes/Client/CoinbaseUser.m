//
//  CoinbaseUser.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseUser.h"

@implementation CoinbaseUser

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _userID = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _email = [dictionary objectForKey:@"email"];
        _timeZone = [dictionary objectForKey:@"time_zone"];
        _nativeCurrency = [dictionary objectForKey:@"native_currency"];
        _balance = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];

        _merchant = [[CoinbaseMerchant alloc] initWithDictionary:[dictionary objectForKey:@"merchant"]];

        _buyLevel = [[dictionary objectForKey:@"buy_level"] unsignedIntegerValue] ;
        _instantBuyLevel = [[dictionary objectForKey:@"instant_buy_level"] unsignedIntegerValue];
        _sellLevel = [[dictionary objectForKey:@"sell_level"] unsignedIntegerValue];

        if([dictionary objectForKey:@"buy_limit"] != [NSNull null])
        {
            _buyLimit = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"buy_limit"]];
        }
        if ([dictionary objectForKey:@"instant_buy_limit"] != [NSNull null])
        {
            _instantBuyLimit = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"instant_buy_limit"]];
        }
        if ([dictionary objectForKey:@"sell_limit"] != [NSNull null])
        {
            _sellLimit = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"sell_limit"]];
        }
        _avatarURL = [dictionary objectForKey:@"avatar_url"];
    }
    return self;
}

@end

@implementation CoinbaseMerchant

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _enabled = [[dictionary objectForKey:@"enabled"] boolValue];
        _companyName = [dictionary objectForKey:@"company_name"];
        _logoSmallURL = [[dictionary objectForKey:@"logo"] objectForKey:@"small"];
        _logoMediumURL = [[dictionary objectForKey:@"logo"] objectForKey:@"medium"];
        _logoURL = [[dictionary objectForKey:@"logo"] objectForKey:@"url"];
    }
    return self;
}

@end
//
//  CoinbaseAuthorization.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseAuthorization.h"

@implementation CoinbaseAuthorization

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _authType = [dictionary objectForKey:@"auth_type"];
        _sendLimitPeriod = [[dictionary objectForKey:@"meta"] objectForKey:@"send_limit_period"];
        _sendLimitCurrency = [[dictionary objectForKey:@"meta"] objectForKey:@"send_limit_currency"];
        _sendLimitAmount = [[dictionary objectForKey:@"meta"] objectForKey:@"send_limit_amount"];
        _scopes = [dictionary objectForKey:@"scopes"];
    }
    return self;
}
@end

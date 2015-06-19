//
//  CoinbasePaymentMethod.m
//  Pods
//
//  Created by Dai Hovey on 21/04/2015.
//
//

#import "CoinbasePaymentMethod.h"

@implementation CoinbasePaymentMethod

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _paymentMethodID = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];
        _currency = [dictionary objectForKey:@"currency"];
        _canBuy = [[dictionary objectForKey:@"can_buy"] boolValue];
        _canSell = [[dictionary objectForKey:@"can_sell"] boolValue];
        _type = [dictionary objectForKey:@"type"];
        _verified = [[dictionary objectForKey:@"verified"] boolValue];
        _accountID = [dictionary objectForKey:@"account_id"];
    }
    return self;
}

@end

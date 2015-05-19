//
//  CoinbaseBalance.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbaseBalance.h"

@implementation CoinbaseBalance

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _amount = [dictionary objectForKey:@"amount"];
        _currency = [dictionary objectForKey:@"currency"];
    }    
    return self;
}

@end

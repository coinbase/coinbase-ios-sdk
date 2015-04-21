//
//  CoinbasePrice.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbasePrice.h"

@implementation CoinbasePrice

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _cents = [dictionary objectForKey:@"cents"];
        _currencyISO = [dictionary objectForKey:@"currency_iso"];
    }
    return self;
}

@end

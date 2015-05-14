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
        if ([[dictionary objectForKey:@"cents"] isKindOfClass:[NSString class]])
        {
            _cents = [dictionary objectForKey:@"cents"];
        }
        else
        {
            _cents = [[dictionary objectForKey:@"cents"] stringValue];
        }

        if ([[dictionary objectForKey:@"currency_iso"] isKindOfClass:[NSString class]])
        {
            _currencyISO = [dictionary objectForKey:@"currency_iso"];
        }
        else
        {
            _currencyISO = [[dictionary objectForKey:@"currency_iso"] stringValue];
        }
    }
    return self;
}

@end

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
        _address = [dictionary objectForKey:@"address"];
        _callbackURL = [dictionary objectForKey:@"callback_url"];
        _label = [dictionary objectForKey:@"label"];
    }
    return self;
}

@end

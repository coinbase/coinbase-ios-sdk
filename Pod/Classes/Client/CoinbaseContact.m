//
//  CoinbaseContact.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseContact.h"

@implementation CoinbaseContact

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _email = [dictionary objectForKey:@"email"];
    }
    return self;
}

@end

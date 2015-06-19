//
//  CoinbaseToken.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseToken.h"

@implementation CoinbaseToken

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _tokenID = [dictionary objectForKey:@"token_id"];
        _address = [dictionary objectForKey:@"address"];
    }
    return self;
}

@end

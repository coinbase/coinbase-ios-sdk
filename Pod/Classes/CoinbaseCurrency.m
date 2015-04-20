//
//  CoinbaseCurrency.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseCurrency.h"

@implementation CoinbaseCurrency

-(id) initWithArray:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        _name = [array objectAtIndex:0];
        _iso = [array objectAtIndex:1];
    }
    return self;
}

@end
//
//  CoinbasePagingHelper.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbasePagingHelper.h"

@implementation CoinbasePagingHelper

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _currentPage = [[dictionary objectForKey:@"current_page"] unsignedIntegerValue];
        _totalPages = [[dictionary objectForKey:@"num_pages"] unsignedIntegerValue];
    }
    return self;
}

@end

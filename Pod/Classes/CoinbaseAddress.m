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

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _type = [dictionary objectForKey:@"type"];
        _redeemScript = [dictionary objectForKey:@"redeem_script"];
    }
    return self;
}

@end

//
//  CoinbaseApplication.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseApplication.h"

@implementation CoinbaseApplication

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _applicationID = [dictionary objectForKey:@"id"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _name = [dictionary objectForKey:@"name"];
        _redirectURL = [dictionary objectForKey:@"redirect_uri"];
        _numberOfUsers = [[dictionary objectForKey:@"num_users"] unsignedIntegerValue];
        _clientID = [dictionary objectForKey:@"client_id"];
        _clientSecret = [dictionary objectForKey:@"client_secret"];
    }
    return self;
}

@end
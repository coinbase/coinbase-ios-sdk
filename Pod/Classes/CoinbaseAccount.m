//
//  CoinbaseAccount.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbaseAccount.h"

@implementation CoinbaseAccount

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _active = [[dictionary objectForKey:@"active"] boolValue];

        _balance = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _accountID = [dictionary objectForKey:@"id"];
        _name = [dictionary objectForKey:@"name"];

        _nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"native_balance"]];

        _primary = [[dictionary objectForKey:@"primary"] boolValue];
        _type = [dictionary objectForKey:@"type"];
    }
    
    return self;
}

@end

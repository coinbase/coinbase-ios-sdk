//
//  CoinbaseTransaction.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseTransaction.h"

@implementation CoinbaseTransaction

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _userID = [dictionary objectForKey:@"id"];
        _hashString = [dictionary objectForKey:@"hsh"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        _sellLimit = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];
        _request = [[dictionary objectForKey:@"request"] boolValue];
        _status = [dictionary objectForKey:@"status"];
        _sender = [[CoinbaseUser alloc] initWithDictionary:[dictionary objectForKey:@"balance"]];
        _recipient = [[CoinbaseUser alloc] initWithDictionary:[dictionary objectForKey:@"recipient"]];
        _recipientAddress = [dictionary objectForKey:@"recipient_address"];
        _idem = [dictionary objectForKey:@"idem"];
        _notes = [dictionary objectForKey:@"notes"];
    }
    return self;
}

@end
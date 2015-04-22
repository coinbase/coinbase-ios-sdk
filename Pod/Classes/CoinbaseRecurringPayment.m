//
//  CoinbaseRecurringPayment.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseRecurringPayment.h"

@implementation CoinbaseRecurringPayment

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _recurringPaymentID = [dictionary objectForKey:@"id"];
        _type = [dictionary objectForKey:@"type"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _to = [dictionary objectForKey:@"to"];
        _from = [dictionary objectForKey:@"from"];
        _startType = [dictionary objectForKey:@"start_type"];
        _times = [[dictionary objectForKey:@"times"] unsignedIntegerValue];
        _timesRun = [[dictionary objectForKey:@"times_run"] unsignedIntegerValue];
        _repeat = [dictionary objectForKey:@"repeat"];
        _lastRun = [dateFormatter dateFromString:[dictionary objectForKey:@"last_run"]];
        _nextRun = [dateFormatter dateFromString:[dictionary objectForKey:@"next_run"]];
        _notes = [dictionary objectForKey:@"notes"];
        _recurringPaymentDescription = [dictionary objectForKey:@"description"];
        _amount = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"amount"]];
    }
    return self;
}

@end

//
//  CoinbaseReport.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseReport.h"

@implementation CoinbaseReport

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _reportID = [dictionary objectForKey:@"id"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        if ([dictionary objectForKey:@"created_at"] != [NSNull null])
        {
            _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];
        }
        if ([dictionary objectForKey:@"last_run"] != [NSNull null])
        {
            _lastRun = [dateFormatter dateFromString:[dictionary objectForKey:@"last_run"]];

        }
        if ([dictionary objectForKey:@"next_run"] != [NSNull null])
        {
            _nextRun = [dateFormatter dateFromString:[dictionary objectForKey:@"next_run"]];
        }

        _type = [dictionary objectForKey:@"type"];
        _status = [dictionary objectForKey:@"status"];
        _email = [dictionary objectForKey:@"email"];
        _repeat = [dictionary objectForKey:@"repeat"];
        _timeRange = [dictionary objectForKey:@"time_range"];
        _callBackURL = [dictionary objectForKey:@"callback_url"];
        _fileURL = [dictionary objectForKey:@"file_url"];
        _times = [[dictionary objectForKey:@"times"] unsignedIntegerValue];
        _timesRun = [[dictionary objectForKey:@"times_run"] unsignedIntegerValue];
        _timeRangeStart = [dictionary objectForKey:@"time_range_start"];
        _timeRangeEnd = [dictionary objectForKey:@"time_range_end"];
        _startType = [dictionary objectForKey:@"start_type"];
        _nextRunDate = [dictionary objectForKey:@"next_run_date"];
        _nextRunTime = [dictionary objectForKey:@"next_run_time"];

    }
    return self;
}

@end

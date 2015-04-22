//
//  CoinbaseRefund.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseRefund.h"

@implementation CoinbaseRefund

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _refundID = [dictionary objectForKey:@"id"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _amountBitcoins = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"amount_btc"]];
        _amountNative = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"amount_native"]];

        _transferID  = [dictionary objectForKey:@"transfer_id"];
        _transactionID = [dictionary objectForKey:@"transaction_id"];
        _refundableID = [[dictionary objectForKey:@"refundable"] objectForKey:@"id"];
        _refundableType = [[dictionary objectForKey:@"refundable"] objectForKey:@"type"];
    }
    return self;
}

@end
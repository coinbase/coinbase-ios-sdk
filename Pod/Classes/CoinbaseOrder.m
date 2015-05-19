//
//  CoinbaseOrder.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseOrder.h"

@implementation CoinbaseOrder

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _orderID = [dictionary objectForKey:@"id"];
        _event = [dictionary objectForKey:@"event"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _status = [dictionary objectForKey:@"status"];
        _totalBitcoins = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"total_btc"]];
        _totalNative = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"total_native"]];
        _totalPayout = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"total_payout"]];
        _mispaidBitcoins = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"mispaid_btc"]];
        _mispaidNative = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"mispaid_native"]];

        _custom = [dictionary objectForKey:@"custom"];
        _receiveAddress = [dictionary objectForKey:@"receive_address"];
        _button = [[CoinbaseButton alloc] initWithDictionary:[dictionary objectForKey:@"button"]];
        _refundAddress = [dictionary objectForKey:@"refund_address"];

        if ([dictionary objectForKey:@"transaction"] != [NSNull null])
        {
            _transaction = [[CoinbaseTransaction alloc] initWithDictionary:[dictionary objectForKey:@"transaction"]];
        }
        if ([dictionary objectForKey:@"refund_transaction"] != [NSNull null])
        {
            _refundTransaction = [[CoinbaseTransaction alloc] initWithDictionary:[dictionary objectForKey:@"refund_transaction"]];
        }
    }
    return self;
}
@end
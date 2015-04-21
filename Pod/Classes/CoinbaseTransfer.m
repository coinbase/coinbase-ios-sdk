//
//  CoinbaseTransfer.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseTransfer.h"

@implementation CoinbaseTransfer

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _transferID = [dictionary objectForKey:@"id"];
        _type = [dictionary objectForKey:@"type"];
        _code = [dictionary objectForKey:@"code"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _coinbaseFees = [[CoinbasePrice alloc] initWithDictionary:[[dictionary objectForKey:@"fees"] objectForKey:@"coinbase"]];
        _bankFees = [[CoinbasePrice alloc] initWithDictionary:[[dictionary objectForKey:@"fees"] objectForKey:@"coinbase"]];

        _payoutDate = [dateFormatter dateFromString:[dictionary objectForKey:@"payout_date"]];

        _transactionID = [dictionary objectForKey:@"transaction_id"];
        _status = [dictionary objectForKey:@"status"];

        _bitcoinAmount = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"btc"]];
        _subTotal = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"subtotal"]];
        _total = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"total"]];
        _transferDescription = [dictionary objectForKey:@"description"];

        _paymentMethod = [[CoinbasePaymentMethod alloc] initWithDictionary:[dictionary objectForKey:@"payment_method"]];
        _detailedStatus = [dictionary objectForKey:@"detailed_status"];
        _accountID = [dictionary objectForKey:@"account"];
    }
    return self;
}

@end

//
//  CoinbaseOrder.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseOrder.h"
#import "CoinbaseInternal.h"

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

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.orderID = theID;
        self.client = client;
    }
    return self;
}

-(void) refundOrderWithRefundISOCode:(NSString *)refundISOCode
                          completion:(void(^)(CoinbaseOrder*, NSError*))callback;
{
    NSDictionary *parameters = @{
                                 @"refund_iso_code" : ObjectOrEmptyString(refundISOCode)
                                 };

    NSString *path = [NSString stringWithFormat:@"orders/%@/refund", _orderID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

-(void) refundOrderWithRefundISOCode:(NSString *)refundISOCode
                        mispaymentID:(NSString *)mispaymentID
               externalRefundAddress:(NSString *)externalRefundAddress
                          instantBuy:(BOOL)instantBuy
                          completion:(void(^)(CoinbaseOrder*, NSError*))callback;
{
    NSDictionary *parameters = @{
                                 @"refund_iso_code" : ObjectOrEmptyString(refundISOCode),
                                 @"mispayment_id" : ObjectOrEmptyString(mispaymentID),
                                 @"external_refund_address" : ObjectOrEmptyString(externalRefundAddress),
                                 @"instant_buy" : instantBuy ? @"true" : @"false"
                                 };

    NSString *path = [NSString stringWithFormat:@"orders/%@/refund", _orderID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
            callback(order, error);
        }
    }];
}

@end
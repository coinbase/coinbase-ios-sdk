//
//  CoinbaseTransfer.m
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import "CoinbaseTransfer.h"
#import "CoinbaseInternal.h"

@implementation CoinbaseTransfer

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _transferID = [dictionary objectForKey:@"id"];
        _type = [dictionary objectForKey:@"type"];
        _underscoreType = [dictionary objectForKey:@"_type"];
        _code = [dictionary objectForKey:@"code"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _coinbaseFees = [[CoinbasePrice alloc] initWithDictionary:[[dictionary objectForKey:@"fees"] objectForKey:@"coinbase"]];
        _bankFees = [[CoinbasePrice alloc] initWithDictionary:[[dictionary objectForKey:@"fees"] objectForKey:@"bank"]];

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

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.transferID = theID;
        self.client = client;
    }
    return self;
}

-(void) commitTransfer:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"transfers/%@/commit", _transferID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

-(void) commitTransferWithAccountID:(NSString *)accountID
                         completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : ObjectOrEmptyString(accountID)
                                 };

    NSString *path = [NSString stringWithFormat:@"transfers/%@/commit", _transferID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
            callback(transfer, error);
        }
    }];
}

@end

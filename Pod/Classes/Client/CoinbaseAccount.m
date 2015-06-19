//
//  CoinbaseAccount.m
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import "CoinbaseAccount.h"
#import "CoinbaseInternal.h"

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
        _m = [[dictionary objectForKey:@"m"] stringValue];
        _n = [[dictionary objectForKey:@"n"] stringValue];
    }
    
    return self;
}

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.accountID = theID;
        self.client = client;
    }
    return self;
}

-(void) getBalance:(void(^)(CoinbaseBalance*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/balance", _accountID];

    [self.client doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];
            callback(balance , error);
        }
    }];
}

-(void) getBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", _accountID];

    [self.client doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];
            callback(address , error);
        }
    }];
}

-(void) modifyWithName:(NSString *)name
                   completion:(void(^)(CoinbaseAccount*, NSError*))callback
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : ObjectOrEmptyString(name)}};

    NSString *path = [NSString stringWithFormat:@"accounts/%@", _accountID];

    [self.client doRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(account , error);
        }
    }];
}

-(void) setAsPrimary:(void(^)(BOOL, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/primary", _accountID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(NO, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            BOOL success = [[response objectForKey:@"success"] boolValue];

            callback(success , error);
        }
    }];
}

-(void) createBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", _accountID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[response objectForKey:@"account"]];
            callback(address , error);
        }
    }];
}

-(void) createBitcoinAddressWithLabel:(NSString *)label
                          callBackURL:(NSString *)callBackURL
                           completion:(void(^)(CoinbaseAddress*, NSError*))callback
{
    NSDictionary *parameters = @{@"address" :
                                     @{@"label" : label,
                                       @"callback_url" : callBackURL
                                       }};

    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", _accountID];

    [self.client doRequestType:CoinbaseRequestTypePost path:path parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response ];
            callback(address , error);
        }
    }];
}

-(void) getAccountAddresses:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : _accountID
                                 };

    [self.client doRequestType:CoinbaseRequestTypeGet path:@"addresses" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseAddresses = [response objectForKey:@"addresses"];

            NSMutableArray *addresses = [[NSMutableArray alloc] initWithCapacity:responseAddresses.count];

            for (NSDictionary *dictionary in responseAddresses)
            {
                CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[dictionary objectForKey:@"address"]];
                [addresses addObject:address];
            }

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(addresses, pagingHelper, error);
        }
    }];
}

-(void) getAccountAddressesWithPage:(NSUInteger)page
                              limit:(NSUInteger)limit
                          accountId:(NSString *)accountId
                              query:(NSString *)query
                         completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"account_id" : accountId,
                                 @"query" : query,
                                 };

    [self.client doRequestType:CoinbaseRequestTypeGet path:@"addresses" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseAddresses = [response objectForKey:@"addresses"];

            NSMutableArray *addresses = [[NSMutableArray alloc] initWithCapacity:responseAddresses.count];

            for (NSDictionary *dictionary in responseAddresses)
            {
                CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[dictionary objectForKey:@"address"]];
                [addresses addObject:address];
            }

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            
            callback(addresses, pagingHelper, error);
        }
    }];
}

-(void) depositAmount:(NSString *)amount
      paymentMethodId:(NSString *)paymentMethodId
               commit:(BOOL)commit
           completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : _accountID,
                                 @"amount" : ObjectOrEmptyString(amount),
                                 @"payment_method_id" : ObjectOrEmptyString(paymentMethodId),
                                 @"commit" : commit ? @"true" : @"false",
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"deposits" parameters:parameters headers:nil completion:^(id response, NSError *error) {

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

#pragma mark - Withdrawals

-(void) withdrawAmount:(NSString *)amount
       paymentMethodID:(NSString *)paymentMethodID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : _accountID,
                                 @"amount" : ObjectOrEmptyString(amount),
                                 @"payment_method_id" : ObjectOrEmptyString(paymentMethodID),
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"withdrawals" parameters:parameters headers:nil completion:^(id response, NSError *error) {

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

-(void) withdrawAmount:(NSString *)amount
       paymentMethodID:(NSString *)paymentMethodID
                commit:(BOOL)commit
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"account_id" : _accountID,
                                 @"amount" : ObjectOrEmptyString(amount),
                                 @"payment_method_id" : ObjectOrEmptyString(paymentMethodID),
                                 @"commit" : commit ? @"true" : @"false"
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"withdrawals" parameters:parameters headers:nil completion:^(id response, NSError *error) {

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

-(void) sendAmount:(NSString *)amount
                to:(NSString *)to
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"to" : ObjectOrEmptyString(to),
                                       @"amount": ObjectOrEmptyString(amount)
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/send_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) sendAmount:(NSString *)amount
                to:(NSString *)to
             notes:(NSString *)notes
           userFee:(NSString *)userFeeString
        referrerID:(NSString *)referrerID
              idem:(NSString *)idem
        instantBuy:(BOOL)instantBuy
           orderID:(NSString *)orderID
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"to" : ObjectOrEmptyString(to),
                                       @"amount": ObjectOrEmptyString(amount),
                                       @"notes" : ObjectOrEmptyString(notes),
                                       @"user_fee" : ObjectOrEmptyString(userFeeString),
                                       @"referrer_id" : ObjectOrEmptyString(referrerID),
                                       @"idem" : ObjectOrEmptyString(idem),
                                       @"instant_buy" : instantBuy ? @"true" : @"false",
                                       @"order_id" : ObjectOrEmptyString(orderID),
                                       @"account_id" : _accountID
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/send_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) sendAmount:(NSString *)amount
 amountCurrencyISO:(NSString *)amountCurrencyISO
                to:(NSString *)to
             notes:(NSString *)notes
           userFee:(NSString *)userFeeString
        referrerID:(NSString *)referrerID
              idem:(NSString *)idem
        instantBuy:(BOOL)instantBuy
           orderID:(NSString *)orderID
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"to" : ObjectOrEmptyString(to),
                                       @"amount": ObjectOrEmptyString(amount),
                                       @"amount_currency_iso" : ObjectOrEmptyString(amountCurrencyISO),
                                       @"notes" : ObjectOrEmptyString(notes),
                                       @"user_fee" : ObjectOrEmptyString(userFeeString),
                                       @"referrer_id" : ObjectOrEmptyString(referrerID),
                                       @"idem" : ObjectOrEmptyString(idem),
                                       @"instant_buy" : instantBuy ? @"true" : @"false",
                                       @"order_id" : ObjectOrEmptyString(orderID),
                                       @"account_id" : _accountID
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/send_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) transferAmount:(NSString *)amount
                    to:(NSString *)to
            completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"to" : ObjectOrEmptyString(to),
                                       @"amount": ObjectOrEmptyString(amount),
                                       @"account_id" : _accountID
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/transfer_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) requestAmount:(NSString *)amount
                 from:(NSString *)from
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"from" : ObjectOrEmptyString(from),
                                       @"amount": ObjectOrEmptyString(amount)
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/request_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) requestAmount:(NSString *)amount
                 from:(NSString *)from
                notes:(NSString *)notes
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"from" : ObjectOrEmptyString(from),
                                       @"amount": ObjectOrEmptyString(amount),
                                       @"notes" : ObjectOrEmptyString(notes),
                                       @"account_id" : _accountID
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/request_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

-(void) requestAmount:(NSString *)amount
    amountCurrencyISO:(NSString *)amountCurrencyISO
                 from:(NSString *)from
                notes:(NSString *)notes
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback
{
    NSDictionary *parameters = @{@"transaction" :
                                     @{@"from" : ObjectOrEmptyString(from),
                                       @"amount": ObjectOrEmptyString(amount),
                                       @"amount_currency_iso" : ObjectOrEmptyString(amountCurrencyISO),
                                       @"notes" : ObjectOrEmptyString(notes),
                                       @"account_id" : _accountID
                                       }
                                 };

    [self.client doRequestType:CoinbaseRequestTypePost path:@"transactions/request_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
            callback(transaction, error);
        }
    }];
}

@end

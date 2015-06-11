//
//  CoinbaseAccountChange.m
//  Pods
//
//  Created by Dai Hovey on 21/04/2015.
//
//

#import "CoinbaseAccountChange.h"

@implementation CoinbaseAccountChange

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _accountChangesID = [dictionary objectForKey:@"id"];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];

        _creationDate = [dateFormatter dateFromString:[dictionary objectForKey:@"created_at"]];

        _transactionID = [dictionary objectForKey:@"transaction_id"];
        _confirmed = [[dictionary objectForKey:@"confirmed"] boolValue];

        // Cache
        NSDictionary *cache = [dictionary objectForKey:@"cache"];
        _applicationID = [cache objectForKey:@"application_id"];
        _blockStatus = [cache objectForKey:@"block_status"];
        _category = [cache objectForKey:@"category"];
        _cacheCreationDate = [dateFormatter dateFromString:[cache objectForKey:@"created_at"]];
        _fiat = [[cache objectForKey:@"fiat"] boolValue];
        _hashString = [cache objectForKey:@"hsh"];
        _idem = [cache objectForKey:@"idem"];
        _multisig = [[cache objectForKey:@"multisig"] boolValue];
        _notes = [cache objectForKey:@"notes"];
        _notesPresent = [[cache objectForKey:@"notes_present"] boolValue];

        _otherUserID = [[cache objectForKey:@"other_user"] objectForKey:@"id"];
        _otherUserName = [[cache objectForKey:@"other_user"] objectForKey:@"name"];
        _otherUserAvatar = [[cache objectForKey:@"other_user"] objectForKey:@"avatar_url"];
        _otherUserUserName = [[cache objectForKey:@"other_user"] objectForKey:@"username"];

        _recipientAccountID = [cache objectForKey:@"recipient_account_id"];
        _recipientAccountUserID = [cache objectForKey:@"recipient_account_user_id"];
        _recipientUserID = [cache objectForKey:@"recipient_user_id"];
        _senderAccountID = [cache objectForKey:@"sender_account_id"];
        _senderAccountUserID = [cache objectForKey:@"sender_account_user_id"];

        _sentToBitcoinAddress = [[cache objectForKey:@"sent_to_bitcoin_address"] boolValue];
        _status = [cache objectForKey:@"status"];
        _tipPresent = [[cache objectForKey:@"tip_present"] boolValue];
        _to = [cache objectForKey:@"to"];
        _transferType = [cache objectForKey:@"transfer_type"];

        _cacheUpdatedDate = [dateFormatter dateFromString:[cache objectForKey:@"updated_at"]];
        
        _amount = [[CoinbaseBalance alloc] initWithDictionary:[dictionary objectForKey:@"amount"]];
    }
    
    return self;
}

-(id) initWithID:(NSString *)theID client:(Coinbase *)client
{
    self = [super init];
    if (self)
    {
        self.accountChangesID = theID;
        self.client = client;
    }
    return self;
}

#pragma mark - Account Changes

-(void) getAccountChanges:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, CoinbasePagingHelper*, NSError*))callback
{
    [self.client doRequestType:CoinbaseRequestTypeGet path:@"account_changes" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
            CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];

            NSArray *responseAccountChanges = [response objectForKey:@"account_changes"];

            NSMutableArray *accountChanges = [[NSMutableArray alloc] initWithCapacity:responseAccountChanges.count];

            for (NSDictionary *dictionary in responseAccountChanges)
            {
                CoinbaseAccountChange *accountChange = [[CoinbaseAccountChange alloc] initWithDictionary:dictionary];
                [accountChanges addObject:accountChange];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(accountChanges, user, balance, nativeBalance, pagingHelper, error);
        }
    }];
}

-(void) getAccountChangesWithPage:(NSUInteger)page
                            limit:(NSUInteger)limit
                        accountId:(NSString *)accountId
                       completion:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, CoinbasePagingHelper*, NSError*))callback
{
    NSDictionary *parameters = @{
                                 @"page" : [@(page) stringValue],
                                 @"limit" : [@(limit)  stringValue],
                                 @"account_id" : accountId
                                 };

    [self.client doRequestType:CoinbaseRequestTypeGet path:@"account_changes" parameters:parameters headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, nil, nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];
            CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
            CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];

            NSArray *responseAccountChanges = [response objectForKey:@"account_changes"];

            NSMutableArray *accountChanges = [[NSMutableArray alloc] initWithCapacity:responseAccountChanges.count];

            for (NSDictionary *dictionary in responseAccountChanges)
            {
                CoinbaseAccountChange *accountChange = [[CoinbaseAccountChange alloc] initWithDictionary:dictionary];
                [accountChanges addObject:accountChange];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];

            callback(accountChanges, user, balance, nativeBalance, pagingHelper, error);
        }
    }];
}

@end

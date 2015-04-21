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

@end

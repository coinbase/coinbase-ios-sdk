//
//  CoinbaseAccountChange.h
//  Pods
//
//  Created by Dai Hovey on 21/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"
#import "CoinbaseObject.h"

@interface CoinbaseAccountChange : CoinbaseObject

@property (nonatomic, strong) NSString *accountChangesID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, assign) BOOL confirmed;

// cache
@property (nonatomic, strong) NSString *applicationID;
@property (nonatomic, strong) NSString *blockStatus;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDate *cacheCreationDate;
@property (nonatomic, assign) BOOL fiat;
@property (nonatomic, strong) NSString *hashString;
@property (nonatomic, strong) NSString *idem;
@property (nonatomic, assign) BOOL multisig;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *otherUserAvatar;
@property (nonatomic, strong) NSString *otherUserID;
@property (nonatomic, strong) NSString *otherUserName;
@property (nonatomic, strong) NSString *otherUserUserName;
@property (nonatomic, strong) NSString *recipientAccountID;
@property (nonatomic, strong) NSString *recipientAccountUserID;
@property (nonatomic, strong) NSString *recipientUserID;
@property (nonatomic, strong) NSString *senderAccountID;
@property (nonatomic, strong) NSString *senderAccountUserID;
@property (nonatomic, assign) BOOL sentToBitcoinAddress;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, assign) BOOL tipPresent;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *transferType;
@property (nonatomic, strong) NSDate *cacheUpdatedDate;
@property (nonatomic, assign) BOOL notesPresent;

@property (nonatomic, strong) CoinbaseBalance *amount;

@end

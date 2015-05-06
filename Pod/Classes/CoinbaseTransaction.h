//
//  CoinbaseTransaction.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"
#import "CoinbaseUser.h"

@interface CoinbaseTransaction : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *hashString;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) CoinbaseBalance *amount;
@property (nonatomic, strong) CoinbaseBalance *sellLimit;
@property (nonatomic, assign) BOOL request;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CoinbaseUser *sender;
@property (nonatomic, strong) CoinbaseUser *recipient;
@property (nonatomic, strong) NSString *recipientAddress;
@property (nonatomic, strong) NSString *idem;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isSigned;
@property (nonatomic, assign) NSUInteger signaturesRequired;
@property (nonatomic, assign) NSUInteger signaturesPresent;
@property (nonatomic, assign) NSUInteger signaturesNeeded;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end
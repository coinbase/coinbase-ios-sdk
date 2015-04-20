//
//  CoinbaseAccount.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"

@interface CoinbaseAccount : NSObject

@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, strong) CoinbaseBalance *balance;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CoinbaseBalance *nativeBalance;
@property (nonatomic, assign, getter=isPrimary) BOOL primary;
@property (nonatomic, strong) NSString *type;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

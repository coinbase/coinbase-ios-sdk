//
//  CoinbaseUser.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"
#import "CoinbaseObject.h"

@class CoinbaseMerchant;

@interface CoinbaseUser : CoinbaseObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *timeZone;
@property (nonatomic, strong) NSString *nativeCurrency;
@property (nonatomic, strong) CoinbaseBalance *balance;
@property (nonatomic, strong) CoinbaseMerchant *merchant;
@property (nonatomic, assign) NSUInteger buyLevel;
@property (nonatomic, assign) NSUInteger instantBuyLevel;
@property (nonatomic, assign) NSUInteger sellLevel;
@property (nonatomic, strong) CoinbaseBalance *buyLimit;
@property (nonatomic, strong) CoinbaseBalance *instantBuyLimit;
@property (nonatomic, strong) CoinbaseBalance *sellLimit;
@property (nonatomic, strong) NSString *avatarURL;

@end


@interface CoinbaseMerchant : CoinbaseObject

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *logoSmallURL;
@property (nonatomic, strong) NSString *logoMediumURL;
@property (nonatomic, strong) NSString *logoURL;


@end

//
//  CoinbaseAuthorization.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseAuthorization : CoinbaseObject

@property (nonatomic, strong) NSString *authType;
@property (nonatomic, strong) NSString *sendLimitPeriod;
@property (nonatomic, strong) NSString *sendLimitCurrency;
@property (nonatomic, strong) NSString *sendLimitAmount;
@property (nonatomic, strong) NSArray *scopes;

@end

//
//  CoinbaseBalance.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseBalance : CoinbaseObject

@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *currency;

@end

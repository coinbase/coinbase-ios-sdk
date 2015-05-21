//
//  CoinbaseCurrency.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseCurrency : CoinbaseObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *iso;

@end

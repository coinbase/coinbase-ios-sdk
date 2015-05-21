//
//  CoinbasePrice.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbasePrice : CoinbaseObject

@property (nonatomic, strong) NSString *cents;
@property (nonatomic, strong) NSString *currencyISO;

@end

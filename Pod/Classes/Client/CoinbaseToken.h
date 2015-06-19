//
//  CoinbaseToken.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseToken : CoinbaseObject

@property (nonatomic, strong) NSString *tokenID;
@property (nonatomic, strong) NSString *address;

@end

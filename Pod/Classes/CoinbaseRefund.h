//
//  CoinbaseRefund.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbasePrice.h"
#import "CoinbaseObject.h"

@interface CoinbaseRefund : CoinbaseObject

@property (nonatomic, strong) NSString *refundID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) CoinbasePrice *amountBitcoins;
@property (nonatomic, strong) CoinbasePrice *amountNative;
@property (nonatomic, strong) NSString *transferID;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *refundableID;
@property (nonatomic, strong) NSString *refundableType;

@end

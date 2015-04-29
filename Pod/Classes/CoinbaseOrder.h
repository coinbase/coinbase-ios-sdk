//
//  CoinbaseOrder.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbasePrice.h"
#import "CoinbaseButton.h"
#import "CoinbaseTransaction.h"

@interface CoinbaseOrder : NSObject

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CoinbasePrice *totalBitcoins;
@property (nonatomic, strong) CoinbasePrice *totalNative;
@property (nonatomic, strong) CoinbasePrice *totalPayout;
@property (nonatomic, strong) CoinbasePrice *mispaidBitcoins;
@property (nonatomic, strong) CoinbasePrice *mispaidNative;
@property (nonatomic, strong) NSString *custom;
@property (nonatomic, strong) NSString *receiveAddress;
@property (nonatomic, strong) CoinbaseButton *button;
@property (nonatomic, strong) CoinbaseTransaction *transaction;
@property (nonatomic, strong) CoinbaseTransaction *refundTransaction;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

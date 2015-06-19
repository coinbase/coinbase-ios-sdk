//
//  CoinbaseOrder.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "Coinbase.h"
#import "CoinbasePrice.h"
#import "CoinbaseButton.h"
#import "CoinbaseTransaction.h"
#import "CoinbaseObject.h"

@interface CoinbaseOrder : CoinbaseObject

@property (nonatomic, strong) NSString *orderID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *event;
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
@property (nonatomic, strong) NSString *refundAddress;

///
/// Refund an order - Authenticated resource which refunds an order or a mispayment to an order. Returns a snapshot of the order data, updated with refund transaction details.
/// Required scope: orders or merchant
///

-(void) refundOrderWithRefundISOCode:(NSString *)refundISOCode
                          completion:(void(^)(CoinbaseOrder*, NSError*))callback;

-(void) refundOrderWithRefundISOCode:(NSString *)refundISOCode
                        mispaymentID:(NSString *)mispaymentID
               externalRefundAddress:(NSString *)externalRefundAddress
                          instantBuy:(BOOL)instantBuy
                          completion:(void(^)(CoinbaseOrder*, NSError*))callback;

@end

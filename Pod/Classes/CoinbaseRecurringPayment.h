//
//  CoinbaseRecurringPayment.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"
#import "CoinbaseButton.h"
#import "CoinbaseObject.h"

@interface CoinbaseRecurringPayment : CoinbaseObject

@property (nonatomic, strong) NSString *recurringPaymentID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *to;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *startType;
@property (nonatomic, assign) NSUInteger times;
@property (nonatomic, assign) NSUInteger timesRun;
@property (nonatomic, strong) NSString *repeat;
@property (nonatomic, strong) NSDate *lastRun;
@property (nonatomic, strong) NSDate *nextRun;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *custom;
@property (nonatomic, strong) NSString *recurringPaymentDescription;
@property (nonatomic, strong) CoinbaseBalance *amount;
@property (nonatomic, strong) CoinbaseButton *button;

@end

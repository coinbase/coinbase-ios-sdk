//
//  CoinbaseTransfer.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbasePrice.h"
#import "CoinbaseBalance.h"
#import "CoinbasePaymentMethod.h"

@interface CoinbaseTransfer : NSObject

@property (nonatomic, strong) NSString *transferID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) CoinbasePrice *coinbaseFees;
@property (nonatomic, strong) CoinbasePrice *bankFees;
@property (nonatomic, strong) NSDate *payoutDate;
@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CoinbaseBalance *bitcoinAmount;
@property (nonatomic, strong) CoinbaseBalance *subTotal;
@property (nonatomic, strong) CoinbaseBalance *total;
@property (nonatomic, strong) NSString *transferDescription;
@property (nonatomic, strong) CoinbasePaymentMethod *paymentMethod;
@property (nonatomic, strong) NSString *detailedStatus;
@property (nonatomic, strong) NSString *accountID;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

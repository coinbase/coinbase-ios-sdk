//
//  CoinbasePaymentMethod.h
//  Pods
//
//  Created by Dai Hovey on 21/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbasePaymentMethod : NSObject

@property (nonatomic, strong) NSString *paymentMethodID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, assign) BOOL canBuy;
@property (nonatomic, assign) BOOL canSell;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL verified;
@property (nonatomic, strong) NSString *accountID;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

//
//  CoinbaseButton.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "Coinbase.h"
#import "CoinbasePrice.h"
#import "CoinbaseObject.h"

@interface CoinbaseButton : CoinbaseObject

@property (nonatomic, strong) NSString *buttonID;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL subscription;
@property (nonatomic, strong) NSString *style;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *buttonDescription;
@property (nonatomic, strong) NSString *custom;
@property (nonatomic, strong) NSString *callbackURL;
@property (nonatomic, strong) CoinbasePrice *price;

///
/// List orders for a button - Authenticated resource which lets you obtain the orders associated with a given button.
/// Required scope: buttons or merchant
///

-(void)getOrdersForButton:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;

@end

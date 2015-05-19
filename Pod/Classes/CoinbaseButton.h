//
//  CoinbaseButton.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbasePrice.h"

@interface CoinbaseButton : NSObject

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

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

//
//  CoinbaseAuthorization.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseAuthorization : NSObject

@property (nonatomic, strong) NSString *authType;
@property (nonatomic, strong) NSString *sendLimitPeriod;
@property (nonatomic, strong) NSString *sendLimitCurrency;
@property (nonatomic, strong) NSString *sendLimitAmount;
@property (nonatomic, strong) NSArray *scopes;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

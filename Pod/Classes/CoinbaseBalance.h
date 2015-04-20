//
//  CoinbaseBalance.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseBalance : NSObject

@property (nonatomic, assign) double amount;
@property (nonatomic, strong) NSString *currency;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

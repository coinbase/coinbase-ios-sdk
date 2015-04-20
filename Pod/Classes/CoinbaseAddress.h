//
//  CoinbaseAddress.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseAddress : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *callbackURL;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *redeemScript;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

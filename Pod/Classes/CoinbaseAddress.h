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

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

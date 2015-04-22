//
//  CoinbaseToken.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseToken : NSObject

@property (nonatomic, strong) NSString *tokenID;
@property (nonatomic, strong) NSString *address;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

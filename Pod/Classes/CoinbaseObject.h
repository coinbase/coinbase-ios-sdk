//
//  CoinbaseObject.h
//  Pods
//
//  Created by Dai Hovey on 21/05/2015.
//
//

#import <Foundation/Foundation.h>
#import "Coinbase.h"

@class Coinbase;

@interface CoinbaseObject : NSObject

@property (nonatomic, strong) Coinbase *client;

-(id) initWithDictionary:(NSDictionary*) dictionary;

-(id) initWithDictionary:(NSDictionary*) dictionary client:(Coinbase *) client;

-(id) initWithArray:(NSArray*) array;

-(id) initWithID:(NSString *) theID client:(Coinbase *) client;

@end

//
//  CoinbaseCurrency.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseCurrency : NSObject

@property (nonatomic, assign) NSString *name;
@property (nonatomic, strong) NSString *iso;

-(id) initWithArray:(NSArray*)array;

@end

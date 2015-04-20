//
//  CoinbaseContact.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbaseContact : NSObject

@property (nonatomic, strong) NSString *email;

-(id) initWithDictionary:(NSDictionary*)dictionary;

@end

//
//  CoinbasePagingHelper.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>

@interface CoinbasePagingHelper : NSObject

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger totalPages;

-(id) initWithDictionary:(NSDictionary*) dictionary;

@end

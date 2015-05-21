//
//  CoinbaseApplication.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseApplication : CoinbaseObject

@property (nonatomic, strong) NSString *applicationID;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *redirectURL;
@property (nonatomic, assign) NSUInteger numberOfUsers;
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;

@end

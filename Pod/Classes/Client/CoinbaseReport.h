//
//  CoinbaseReport.h
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseReport : CoinbaseObject

@property (nonatomic, strong) NSString *reportID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *repeat;
@property (nonatomic, strong) NSString *timeRange;
@property (nonatomic, strong) NSString *timeRangeStart;
@property (nonatomic, strong) NSString *timeRangeEnd;
@property (nonatomic, strong) NSString *startType;
@property (nonatomic, strong) NSString *callBackURL;
@property (nonatomic, strong) NSString *fileURL;
@property (nonatomic, assign) NSUInteger times;
@property (nonatomic, assign) NSUInteger timesRun;
@property (nonatomic, strong) NSDate *lastRun;
@property (nonatomic, strong) NSDate *nextRun;
@property (nonatomic, strong) NSString *nextRunDate;
@property (nonatomic, strong) NSString *nextRunTime;
@property (nonatomic, strong) NSDate *creationDate;

@end

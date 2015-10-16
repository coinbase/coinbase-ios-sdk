//
//  CoinbaseCertificatePinning.h
//  Pods
//
//  Created by David Hovey on 15/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface CoinbaseCertificatePinning : NSObject <NSURLSessionDelegate>

+ (instancetype)shared;

- (void) setupSSLPins;

@end

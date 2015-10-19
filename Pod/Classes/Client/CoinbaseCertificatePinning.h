//
//  CoinbaseCertificatePinning.h
//  Pods
//
//  Created by Dai Hovey on 19/10/2015.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonHMAC.h>

@interface CoinbaseCertificatePinning : NSObject <NSURLSessionDelegate>

+ (instancetype)shared;

-(void) setupCertificates;

@end

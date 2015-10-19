//
//  CoinbaseCertificatePinning.m
//  Pods
//
//  Created by Dai Hovey on 19/10/2015.
//
//

#import "CoinbaseCertificatePinning.h"

@interface CoinbaseCertificatePinning ()
@property CFArrayRef certChaninArrayRef;
@end

@implementation CoinbaseCertificatePinning

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static CoinbaseCertificatePinning *instance;
    dispatch_once(&onceToken, ^{ instance = [[[self class] alloc] init]; });
    return instance;
}

-(void) setupCertificates
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CBCertificates" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSArray *paths = [bundle pathsForResourcesOfType:@"der" inDirectory:@"."];
    
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
    for (NSString *path in paths) {
        NSData *certificateData = [NSData dataWithContentsOfFile:path];
        SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData);
        [certificates addObject:(__bridge id _Nonnull)(cert)];
        self.certChaninArrayRef = CFBridgingRetain(certificates);
    }
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {

        SecTrustRef trust = challenge.protectionSpace.serverTrust;
        SecTrustResultType result;
        OSStatus err = errSecSuccess;
       
        if (err == errSecSuccess) {
            err = SecTrustSetAnchorCertificates(trust,self.certChaninArrayRef);
        }

        if (err == errSecSuccess) {
            err = SecTrustSetAnchorCertificatesOnly(trust, YES);
        }
        
        if (err == errSecSuccess) {
            err = SecTrustEvaluate(trust, &result);
        }
        
        if (err == errSecSuccess) {
            switch (result) {
                case kSecTrustResultProceed:
                    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:trust]);
                    return;
                    break;
                case kSecTrustResultUnspecified:
                    completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:trust]);
                    return;
                    break;
                case kSecTrustResultInvalid:
                    break;
                case kSecTrustResultDeny:
                    break;
                case kSecTrustResultFatalTrustFailure:
                    break;
                case kSecTrustResultOtherError:
                    break;
                case kSecTrustResultRecoverableTrustFailure:
                    break;
                default:
                    NSAssert(NO,@"Unexpected result: %d", result);
                    break;
            }
        };
    
    completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
        return;
    }
}

@end

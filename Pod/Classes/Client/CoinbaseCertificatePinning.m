//
//  CoinbaseCertificatePinning.m
//  Pods
//
//  Created by Dai Hovey on 15/10/2015.
//
// Based upon ISPCertificatePinning by Alban Diquet. Copyright (c) 2014 iSEC Partners.
// https://github.com/iSECPartners/ssl-conservatory/tree/master/ios/SSLCertificatePinning
//

#import "CoinbaseCertificatePinning.h"

@implementation CoinbaseCertificatePinning

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static CoinbaseCertificatePinning *instance;
    dispatch_once(&onceToken, ^{ instance = [[[self class] alloc] init]; });
    return instance;
}

-(void) setupSSLPins
{
    NSArray *domainsToPin = [self fetchPinnedCertificates];
    if (domainsToPin == nil) {
        NSLog(@"Failed to pin a certificate");
    }
    // Save the SSL pins so that our session delegates automatically use them
    if ([self fetchPinnedCertificates:domainsToPin] != YES) {
        NSLog(@"Failed to pin the certificates");
    }
}

- (NSArray*) fetchPinnedCertificates {
    // Build array of domain => certificates
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"CBCertificates" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSArray *paths = [bundle pathsForResourcesOfType:@"der" inDirectory:@"."];
    
    NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
    for (NSString *path in paths) {
        NSData *certificateData = [NSData dataWithContentsOfFile:path];
        [certificates addObject:certificateData];
    }
    
    return certificates;
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
        
    if([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
        SecTrustResultType trustResult;
        
        // Validate the certificate chain with the device's trust store anyway
        // This *might* give use revocation checking
        SecTrustEvaluate(serverTrust, &trustResult);
        if (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified) {
            // Look for a pinned certificate in the server's certificate chain
            if ([self verifyPinnedCertificateForTrust:serverTrust]) {
                // Found the certificate; continue connecting
                completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
                return;
            }
        }
        // Certificate chain validation failed; cancel the connection
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
    }
}

// All the pinned certificate are stored in this plist on the filesystem
#define PINNED_KEYS_FILE_PATH "~/Library/SSLPins.plist"

- (BOOL)fetchPinnedCertificates:(NSArray*)certificates {
    if (certificates == nil) {
        return NO;
    }
    
    // Serialize the dictionary to a plist
    NSError *error;
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:certificates
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                                  options:0
                                                                    error:&error];
    if (plistData == nil) {
        NSLog(@"Error serializing plist: %@", error);
        return NO;
    }
    
    // Write the plist to a pre-defined location on the filesystem
    NSError *writeError;
    if ([plistData writeToFile:[@PINNED_KEYS_FILE_PATH stringByExpandingTildeInPath]
                       options:NSDataWritingAtomic
                         error:&writeError] == NO) {
        NSLog(@"Error saving plist to the filesystem: %@", writeError);
        return NO;
    }
    
    return YES;
}


- (BOOL)verifyPinnedCertificateForTrust:(SecTrustRef)trust {
    if (trust == NULL) {
        return NO;
    }
    
    // Deserialize the plist that contains our SSL pins
    NSArray *trustedCertificates = [NSArray arrayWithContentsOfFile:[@PINNED_KEYS_FILE_PATH stringByExpandingTildeInPath]];
    if (trustedCertificates == nil) {
        NSLog(@"Error accessing the SSL Pins plist at %@", @PINNED_KEYS_FILE_PATH);
        return NO;
    }
    
    // Do we have certificates pinned for this domain ?
    if ((trustedCertificates == nil) || ([trustedCertificates count] < 1)) {
        return NO;
    }
    
    // For each pinned certificate, check if it is part of the server's cert trust chain
    // We only need one of the pinned certificates to be in the server's trust chain
    for (NSData *pinnedCertificate in trustedCertificates) {
        
        // Check each certificate in the server's trust chain (the trust object)
        // Unfortunately the anchor/CA certificate cannot be accessed this way
        CFIndex certsNb = SecTrustGetCertificateCount(trust);
        for(int i=0;i<certsNb;i++) {
            
            // Extract the certificate
            SecCertificateRef certificate = SecTrustGetCertificateAtIndex(trust, i);
            NSData* DERCertificate = (__bridge NSData*) SecCertificateCopyData(certificate);
            
            // Compare the two certificates
            if ([pinnedCertificate isEqualToData:DERCertificate]) {
                return YES;
            }
        }
        
        // Check the anchor/CA certificate separately
        SecCertificateRef anchorCertificate = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)(pinnedCertificate));
        if (anchorCertificate == NULL) {
            break;
        }
        
        NSArray *anchorArray = [NSArray arrayWithObject:(__bridge id)(anchorCertificate)];
        if (SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef)(anchorArray)) != 0) {
            CFRelease(anchorCertificate);
            break;
        }
        
        SecTrustResultType trustResult;
        SecTrustEvaluate(trust, &trustResult);
        if (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified) {
            // The anchor certificate was pinned
            CFRelease(anchorCertificate);
            return YES;
        }
        CFRelease(anchorCertificate);
    }
    
    // If we get here, we didn't find any matching certificate in the chain
    return NO;
}

@end

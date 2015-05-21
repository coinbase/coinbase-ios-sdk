//
//  CoinbaseTransaction.h
//  Pods
//
//  Created by Dai Hovey on 20/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "Coinbase.h"
#import "CoinbaseBalance.h"
#import "CoinbaseUser.h"
#import "CoinbaseObject.h"

@interface CoinbaseTransaction : CoinbaseObject

@property (nonatomic, strong) NSString *transactionID;
@property (nonatomic, strong) NSString *hashString;
@property (nonatomic, strong) NSString *hshString;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) CoinbaseBalance *amount;
@property (nonatomic, strong) CoinbaseBalance *sellLimit;
@property (nonatomic, assign) BOOL request;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) CoinbaseUser *sender;
@property (nonatomic, strong) CoinbaseUser *recipient;
@property (nonatomic, strong) NSString *recipientAddress;
@property (nonatomic, strong) NSString *idem;
@property (nonatomic, strong) NSString *notes;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) BOOL isSigned;
@property (nonatomic, assign) NSUInteger signaturesRequired;
@property (nonatomic, assign) NSUInteger signaturesPresent;
@property (nonatomic, assign) NSUInteger signaturesNeeded;
@property (nonatomic, strong) NSArray *inputArray;
@property (nonatomic, assign) NSUInteger confirmations;

///
/// Get signature hashes for each input that needs signing in a spend from multisig transaction - Authenticated resource which lets you fetch signature hashes.
///

-(void) getSignatureHashes:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) getSignatureHashesWithAccountID:(NSString *)accountID
                             completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Submit required signatures for a multisig spend transaction
///

/*

 signatures arrays format:

 @[
    @{
        @"position": @1,
        @"signatures":
        @[
            @"304502206f73b2147662c70fb6a951e6ddca79ce1e800a799be543d13c9d22817affb997022100b32a96c20a514783cc5135dde9a8a9608b0b55b6c0db01d553c77c544034274d",
            @"304502204930529e97c2c75bbc3b07a365cf691f5bf319bf0a54980785bb525bd996cb1a022100a7e9e3728444a39c7a45822c3c773a43a888432dfe767ea17e1fab8ac2bfc83f"
        ]
    }
 ];

 */

-(void) requiredSignaturesForMultiSig:(NSArray *)signatures
                           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Resend bitcoin request - Authenticated resource which lets the user resend a money request.
/// Required scope: request
///

-(void) resendRequest:(void(^)(BOOL, NSError*))callback;

-(void) resendRequestWithAccountID:(NSString *)accountID
                        completion:(void(^)(BOOL, NSError*))callback;

///
/// Complete bitcoin request - Authenticated resource which lets the recipient of a money request complete the request by sending money to the user who requested the money.
/// Required scope: request
///

-(void) completeRequest:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) completeRequestWithAccountID:(NSString *)accountID
                          completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Cancel bitcoin request - Authenticated resource which lets a user cancel a money request.
/// Required scope: request
///

-(void) cancelRequest:(void(^)(BOOL, NSError*))callback;

-(void) cancelRequestWithAccountID:(NSString *)accountID
                        completion:(void(^)(BOOL, NSError*))callback;


@end
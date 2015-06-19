//
//  CoinbaseAddress.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseObject.h"

@interface CoinbaseAddress : CoinbaseObject

@property (nonatomic, strong) NSString *addressID;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *callbackURL;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *redeemScript;

/// Create a new bitcoin address for an account - Authenticated resource that generates a new bitcoin receive address for the user.
/// Required scope: address
///
-(void) createBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback;

-(void) createBitcoinAddressWithAccountID:(NSString*)accountID
                                    label:(NSString *)label
                          callBackURL:(NSString *)callBackURL
                           completion:(void(^)(CoinbaseAddress*, NSError*))callback;

@end

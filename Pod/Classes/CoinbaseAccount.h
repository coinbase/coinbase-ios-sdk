//
//  CoinbaseAccount.h
//  Pods
//
//  Created by Dai Hovey on 17/04/2015.
//
//

#import <Foundation/Foundation.h>
#import "CoinbaseBalance.h"
#import "CoinbaseAddress.h"
#import "Coinbase.h"
#import "CoinbaseObject.h"

@interface CoinbaseAccount : CoinbaseObject

@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, strong) CoinbaseBalance *balance;
@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) CoinbaseBalance *nativeBalance;
@property (nonatomic, assign, getter=isPrimary) BOOL primary;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *m;
@property (nonatomic, strong) NSString *n;


///
/// Get account’s balance - Authenticated resource that returns the user’s current account balance in BTC.
/// Required scope: balance
///

-(void) getBalance:(void(^)(CoinbaseBalance*, NSError*))callback;

///
/// Get account’s bitcoin address - Authenticated resource that returns the user’s current bitcoin receive address. This can be used to generate scannable QR codes in the bitcoin URI format or to send the receive address to other users.
/// Required scope: address
///

-(void) getBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback;

///
/// Modify an account
///

-(void) modifyWithName:(NSString *)name
            completion:(void(^)(CoinbaseAccount*, NSError*))callback;

///
/// Set account as primary - Authenticated resource that lets you set the primary status on a specific account. You must pass the :account_id of the account in the url.
///

-(void) setAsPrimary:(void(^)(BOOL, NSError*))callback;

@end

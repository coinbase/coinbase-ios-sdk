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
#import "CoinbaseTransfer.h"
#import "CoinbaseTransaction.h"

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


/// Create a new bitcoin address for an account - Authenticated resource that generates a new bitcoin receive address for the user.
/// Required scope: address
///

-(void) createBitcoinAddress:(void(^)(CoinbaseAddress*, NSError*))callback;

-(void) createBitcoinAddressWithLabel:(NSString *)label
                          callBackURL:(NSString *)callBackURL
                           completion:(void(^)(CoinbaseAddress*, NSError*))callback;

///
/// List bitcoin addresses - Authenticated resource that returns bitcoin addresses a user has associated with their account.
/// Required scope: addresses
///

-(void) getAccountAddresses:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;

-(void) getAccountAddressesWithPage:(NSUInteger)page
                              limit:(NSUInteger)limit
                          accountId:(NSString *)accountId
                              query:(NSString *)query
                         completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;

#pragma mark - Deposits

///
/// Deposit USD - Authenticated resource that lets you deposit USD into a USD wallet. You must have a valid USD wallet and bank account connected to use this endpoint.
/// Required scope: deposit
///

-(void) depositAmount:(NSString *)amount
      paymentMethodId:(NSString *)paymentMethodId
               commit:(BOOL)commit
           completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

///
/// Send money - Authenticated resource which lets you send money to an email address, bitcoin address or Coinbase account ID.
/// Required scope: send
///

-(void) sendAmount:(NSString *)amount
                to:(NSString *)to
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

/// Bitcoin amount

-(void) sendAmount:(NSString *)amount
                to:(NSString *)to
             notes:(NSString *)notes
           userFee:(NSString *)userFeeString
        referrerID:(NSString *)referrerID
              idem:(NSString *)idem
        instantBuy:(BOOL)instantBuy
           orderID:(NSString *)orderID
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

/// Currency amount

-(void) sendAmount:(NSString *)amount
 amountCurrencyISO:(NSString *)amountCurrencyISO
                to:(NSString *)to
             notes:(NSString *)notes
           userFee:(NSString *)userFeeString
        referrerID:(NSString *)referrerID
              idem:(NSString *)idem
        instantBuy:(BOOL)instantBuy
           orderID:(NSString *)orderID
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Transfer money between accounts - Authenticated resource which lets you transfer bitcoin between authenticated user’s accounts.
/// Required scope: transfer
///

-(void) transferAmount:(NSString *)amount
                    to:(NSString *)to
            completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Request money - Authenticated resource which lets the user request money from an email address.
/// Required scope: request
///

-(void) requestAmount:(NSString *)amount
                 from:(NSString *)from
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

/// Bitcoin amount

-(void) requestAmount:(NSString *)amount
                 from:(NSString *)from
                notes:(NSString *)notes
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

/// Currency amount

-(void) requestAmount:(NSString *)amount
    amountCurrencyISO:(NSString *)amountCurrencyISO
                 from:(NSString *)from
                notes:(NSString *)notes
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

#pragma mark - Withdrawals

///
/// Withdraw USD or EUR - Authenticated resource that lets you withdraw USD or EUR from a USD or EUR wallet.
/// Required scope: withdraw
///

-(void) withdrawAmount:(NSString *)amount
       paymentMethodID:(NSString *)paymentMethodID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

-(void) withdrawAmount:(NSString *)amount
       paymentMethodID:(NSString *)paymentMethodID
                commit:(BOOL)commit
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

@end

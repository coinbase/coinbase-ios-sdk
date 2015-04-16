#import <Foundation/Foundation.h>
#import "CoinbaseDefines.h"

/// HTTP methods for use with the Coinbase API.
typedef NS_ENUM(NSUInteger, CoinbaseRequestType) {
    CoinbaseRequestTypeGet,
    CoinbaseRequestTypePost,
    CoinbaseRequestTypePut,
    CoinbaseRequestTypeDelete
};

/// The `Coinbase` class is the interface to the Coinbase API. Create a `Coinbase` object using
/// `coinbaseWithOAuthAccessToken:` or `coinbaseWithApiKey:secret:` to call API methods.
@interface Coinbase : NSObject

/// Create a Coinbase object for an OAuth access token. Please note that when this access token
/// expires, requests made on this object will start failing with a 401 Unauthorized error. Obtain new tokens
/// with your refresh token if this occurs.
+ (Coinbase *)coinbaseWithOAuthAccessToken:(NSString *)accessToken;

/// Create a Coinbase object for an API key and secret.
+ (Coinbase *)coinbaseWithApiKey:(NSString *)key
                          secret:(NSString *)secret;

/// Create a Coinbase object with no authentication. You can only use unauthenticated APIs with this client.
+ (Coinbase *)unauthenticatedCoinbase;

#pragma mark - Accounts

///
/// List accounts - Authenticated resource that returns the user’s active accounts.
///

-(void) getAccountsList:(CoinbaseCompletionBlock)completion;

-(void) getAccountsListWithPage:(NSUInteger)page
                          limit:(NSUInteger)limit
                    allAccounts:(NSUInteger)allAccounts
                     completion:(CoinbaseCompletionBlock)completion;

///
// Show an account - Authenticated resource that returns one of user’s active accounts.
//

-(void) getAccount:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

-(void) getPrimaryAccount:(CoinbaseCompletionBlock)completion;

///
// Create an account - Authenticated resource that will create a new account for the user.
/// Required scope: user
//

-(void) createAccountWithName:(NSString *)name
                   completion:(CoinbaseCompletionBlock)completion;

///
/// Get account’s balance - Authenticated resource that returns the user’s current account balance in BTC.
/// Required scope: balance
///

-(void) getBalanceForAccount:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

///
/// Get account’s bitcoin address - Authenticated resource that returns the user’s current bitcoin receive address. This can be used to generate scannable QR codes in the bitcoin URI format or to send the receive address to other users.
/// Required scope: address
///

-(void) getBitcoinAddressForAccount:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

///
/// Create a new bitcoin address for an account - Authenticated resource that generates a new bitcoin receive address for the user.
/// Required scope: address
///

-(void) createBitcoinAddressForAccount:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

-(void) createBitcoinAddressForAccount:(NSString *)accountID
                                 label:(NSString *)label
                           callBackURL:(NSString *)callBackURL
                            completion:(CoinbaseCompletionBlock)completion;

///
/// Modify an account
///

-(void) modifyAccount:(NSString *)accountID
                 name:(NSString *)name
           completion:(CoinbaseCompletionBlock)completion;

///
/// Set account as primary - Authenticated resource that lets you set the primary status on a specific account. You must pass the :account_id of the account in the url.
///

-(void) setAccountAsPrimary:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

///
/// Delete an account - Authenticated resource that will delete an account. Only non-primary accounts with zero balance can be deleted.
///

-(void) deleteAccount:(NSString *)accountID completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Account Changes

///
/// List changes to an account - Authenticated resource which returns all related changes to an account. This is an alternative to the list transactions api call. It is designed to be faster and provide more detail so you can generate an overview/summary of individual account and their recent changes.
/// Required scope: transactions
///

-(void) getAccountChanges:(CoinbaseCompletionBlock)completion;

-(void) getAccountChangesWithPage:(NSUInteger)page
                            limit:(NSUInteger)limit
                        accountId:(NSString *)accountId
                       completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Addresses

///
/// List bitcoin addresses - Authenticated resource that returns bitcoin addresses a user has associated with their account.
/// Required scope: addresses
///

-(void) getAccountAddresses:(CoinbaseCompletionBlock)completion;

-(void) getAccountAddressesWithPage:(NSUInteger)page
                              limit:(NSUInteger)limit
                          accountId:(NSString *)accountId
                              query:(NSString *)query
                         completion:(CoinbaseCompletionBlock)completion;

///
/// Show bitcoin address - Authenticated resource that returns a bitcoin address with its id or address.
/// Required scope: addresses
///

-(void) getAddressWithAddressOrID:(NSString *)addressOrID completion:(CoinbaseCompletionBlock)completion;

-(void) getAddressWithAddressOrID:(NSString *)addressOrID
                        accountId:(NSString *)accountId
                       completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Authorization

///
/// Show authorization information - Authenticated resource that returns information about the current API authorization for user.
///

-(void) getAuthorizationInformation:(CoinbaseCompletionBlock)completion;

#pragma mark - Buys

///
/// Buy bitcoin - Authenticated resource that lets you purchase bitcoin using a bank account that is linked to your account. You must link and verify a bank account through the website before this api call will work, otherwise error is returned.
/// Required scope: buy

-(void) buy:(double)quantity completion:(CoinbaseCompletionBlock)completion;

-(void)                 buy:(double)quantity
                  accountID:(NSString *)accountID
                   currency:(NSString *)currency
       agreeBTCAmountVaries:(BOOL)agreeBTCAmountVaries
                     commit:(BOOL)commit
            paymentMethodID:(NSString *)paymentMethodID
                 completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Contacts

///
/// List emails the user has previously used for autocompletion - Authenticated resource that returns contacts the user has previously sent to or received from.
/// Required scope: contacts
///

-(void) getContacts:(CoinbaseCompletionBlock)completion;

-(void) getContactsWithPage:(NSUInteger)page
                      limit:(NSUInteger)limit
                      query:(NSString *)query
                 completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Currencies

///
/// List currencies supported by Coinbase - Unauthenticated resource that returns currencies supported on Coinbase
///

-(void) getSupportedCurrencies:(CoinbaseCompletionBlock)completion;

///
/// List exchange rates between BTC and other currencies - Unauthenticated resource that returns BTC to fiat (and vice versus) exchange rates in various currencies.
///

-(void) getExchangeRates:(CoinbaseCompletionBlock)completion;

#pragma mark - Deposits

///
/// Deposit USD - Authenticated resource that lets you deposit USD into a USD wallet. You must have a valid USD wallet and bank account connected to use this endpoint.
/// Required scope: deposit
///

-(void) makeDepositToAccount:(NSString *)accountID
                      amount:(double)amount
             paymentMethodId:(NSString *)paymentMethodId
                      commit:(BOOL)commit
                  completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Multisig

///
/// Create a multisig account - Authenticated endpoint to create accounts.
///

-(void) createMultiSigAccountWithName:(NSString *)name
                                 type:(NSString *)type
                   requiredSignatures:(NSUInteger)requiredSignatures
                             xPubKeys:(NSArray *)xPubKeys
                           completion:(CoinbaseCompletionBlock)completion;

///
/// Create a multisig transaction - Authenticated resource which lets you send money to an email or bitcoin address.
/// Required scope: send
///

#warning Todo - Same as POST /v1/transactions/send_money

///
/// Get signature hashes for each input that needs signing in a spend from multisig transaction - Authenticated resource which lets you fetch signature hashes.
///

-(void) getSignatureHashesWithTransactionID:(NSString *)transactionID
                                 completion:(CoinbaseCompletionBlock)completion;

-(void) getSignatureHashesWithTransactionID:(NSString *)transactionID
                                  accountID:(NSString *)accountID
                                 completion:(CoinbaseCompletionBlock)completion;

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

-(void) signaturesForMultiSigTransaction:(NSString *)transactionID
                              signatures:(NSArray *)signatures
                              completion:(CoinbaseCompletionBlock)completion;

#pragma mark - OAuth Applications

///
/// List OAuth applications - List the OAuth applications you have created.
/// Required scope: oauth_apps
///

-(void) getOAuthApplications:(CoinbaseCompletionBlock)completion;

-(void) getOAuthApplicationsWithPage:(NSUInteger)page
                               limit:(NSUInteger)limit
                          completion:(CoinbaseCompletionBlock)completion;

///
/// Show an OAuth application - Show an individual OAuth application you have created.
/// Required scope: oauth_apps
///

-(void) getOAuthApplicationWithID:(NSString *)applicationID
                       completion:(CoinbaseCompletionBlock)completion;

///
/// Create an OAuth application - Create an app that can be given access to other accounts via OAuth2.
///

-(void) createOAuthApplicationWithName:(NSString *)name
                           reDirectURL:(NSString *)reDirectURL
                            completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Orders

///
/// List orders - Authenticated resource which returns a merchant’s orders that they have received.
/// Required scope: orders or merchant
///

-(void) getOrders:(CoinbaseCompletionBlock)completion;

-(void) getOrdersWithPage:(NSUInteger)page
                    limit:(NSUInteger)limit
                accountID:(NSString *)accountID
               completion:(CoinbaseCompletionBlock)completion;

#warning Create an order - Todo?

///
/// Show an order - Authenticated resource which returns order details.
/// Required scope: orders or merchant
///

-(void) getOrderWithID:(NSString *)customFieldOrID
            completion:(CoinbaseCompletionBlock)completion;

-(void) getOrderWithID:(NSString *)customFieldOrID
             accountID:(NSString *)accountID
            completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Transfers

///
/// List buy and sell history - Authenticated resource which returns the user’s bitcoin purchases and sells.
/// Required scope: transfers
///

-(void) getTransfers:(CoinbaseCompletionBlock)completion;

-(void) getTransfersWithPage:(NSUInteger)page
                       limit:(NSUInteger)limit
                   accountID:(NSString *)accountID
                  completion:(CoinbaseCompletionBlock)completion;

///
/// Show a transfer - Authenticated resource which returns a tranfer (a bitcoin purchase or sell).
/// Required scope: transfers
///

-(void) transferWithID:(NSString *)transferID
            completion:(CoinbaseCompletionBlock)completion;

-(void) transferWithID:(NSString *)transferID
             accountID:(NSString *)accountID
            completion:(CoinbaseCompletionBlock)completion;

///
/// Start a transfer that is in the created state - Authenticated resource which completes a transfer that is in the ‘created’ state.
/// Required scope: transfers
///

-(void) commitTransferWithID:(NSString *)transferID
                  completion:(CoinbaseCompletionBlock)completion;

-(void) commitTransferWithID:(NSString *)transferID
                   accountID:(NSString *)accountID
                  completion:(CoinbaseCompletionBlock)completion;

@end

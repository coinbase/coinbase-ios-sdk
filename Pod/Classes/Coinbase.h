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


#pragma mark - Buttons

///
/// Create a new payment button, page, or iFrame - Authenticated resource that creates a payment button, page, or iFrame to accept bitcoin on your website. This can be used to accept bitcoin for an individual item or to integrate with your existing shopping cart solution. For example, you could create a new payment button for each shopping cart on your website, setting the total and order number in the button at checkout.
/// Required scope: buttons or merchant
///

-(void) createButtonWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(CoinbaseCompletionBlock)completion;

-(void) createButtonWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                  accountID:(NSString *)accountID
                       type:(NSString *)type
               subscription:(BOOL)subscription
                     repeat:(NSString *)repeat
                      style:(NSString *)style
                       text:(NSString *)text
                description:(NSString *)description
                     custom:(NSString *)custom
               customSecure:(BOOL)customSecure
                callbackURL:(NSString *)callbackURL
                 successURL:(NSString *)successURL
                  cancelURL:(NSString *)cancelURL
                    infoURL:(NSString *)infoURL
               autoRedirect:(BOOL)autoRedirect
        autoRedirectSuccess:(BOOL)autoRedirectSuccess
         autoRedirectCancel:(BOOL)autoRedirectCancel
              variablePrice:(BOOL)variablePrice
             includeAddress:(BOOL)includeAddress
               includeEmail:(BOOL)includeEmail
                choosePrice:(BOOL)choosePrice
                     price1:(NSString *)price1
                     price2:(NSString *)price2
                     price3:(NSString *)price3
                     price4:(NSString *)price4
                     price5:(NSString *)price5
                 completion:(CoinbaseCompletionBlock)completion;

///
/// Show a button - Authenticated resource which lets you retrieve an individual button.
/// Required scope: buttons or merchant
///

-(void)getButtonWithID:(NSString *)customValueOrID completion:(CoinbaseCompletionBlock)completion;

///
/// Create an order for a button - Authenticated resource which lets you generate an order associated with a button.
/// Required scope: buttons or merchant
///

-(void) createOrderForButtonWithID:(NSString *)customValueOrID completion:(CoinbaseCompletionBlock)completion;

///
/// List orders for a button - Authenticated resource which lets you obtain the orders associated with a given button.
/// Required scope: buttons or merchant
///

-(void)getOrdersForButtonWithID:(NSString *)customValueOrID completion:(CoinbaseCompletionBlock)completion;

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

///
/// Create an order - Authenticated resource which returns an order for a new button.
/// Required scope: orders or merchant
///

-(void) createOrderWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(CoinbaseCompletionBlock)completion;

-(void) createOrderWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                  accountID:(NSString *)accountID
                       type:(NSString *)type
               subscription:(BOOL)subscription
                     repeat:(NSString *)repeat
                      style:(NSString *)style
                       text:(NSString *)text
                description:(NSString *)description
                     custom:(NSString *)custom
               customSecure:(BOOL)customSecure
                callbackURL:(NSString *)callbackURL
                 successURL:(NSString *)successURL
                  cancelURL:(NSString *)cancelURL
                    infoURL:(NSString *)infoURL
               autoRedirect:(BOOL)autoRedirect
        autoRedirectSuccess:(BOOL)autoRedirectSuccess
         autoRedirectCancel:(BOOL)autoRedirectCancel
              variablePrice:(BOOL)variablePrice
             includeAddress:(BOOL)includeAddress
               includeEmail:(BOOL)includeEmail
                choosePrice:(BOOL)choosePrice
                     price1:(NSString *)price1
                     price2:(NSString *)price2
                     price3:(NSString *)price3
                     price4:(NSString *)price4
                     price5:(NSString *)price5
                 completion:(CoinbaseCompletionBlock)completion;

///
/// Show an order - Authenticated resource which returns order details.
/// Required scope: orders or merchant
///

-(void) getOrderWithID:(NSString *)customFieldOrID
            completion:(CoinbaseCompletionBlock)completion;

-(void) getOrderWithID:(NSString *)customFieldOrID
             accountID:(NSString *)accountID
            completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Payment Methods

///
/// List payment methods - Lists all of the payment methods associated with your account
/// Required scope: buy or sell
///

-(void) getPaymentMethods:(CoinbaseCompletionBlock)completion;

///
/// Show a payment method - Lists individual payment method associated with your account.
/// Required scope: buy or sell
///

-(void) paymentMethodWithID:(NSString *)paymentMethodID completion:(CoinbaseCompletionBlock)completion;
///
/// Refund an order - Authenticated resource which refunds an order or a mispayment to an order. Returns a snapshot of the order data, updated with refund transaction details.
/// Required scope: orders or merchant
///

-(void) refundOrderWithID:(NSString *)customFieldOrID
            refundISOCode:(NSString *)refundISOCode
            completion:(CoinbaseCompletionBlock)completion;

-(void) refundOrderWithID:(NSString *)customFieldOrID
            refundISOCode:(NSString *)refundISOCode
             mispaymentID:(NSString *)mispaymentID
    externalRefundAddress:(NSString *)externalRefundAddress
               instantBuy:(BOOL)instantBuy
               completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Prices

///
/// Get the buy price for bitcoin - Resource that tells you the total price to buy some amount of bitcoin.
///

-(void) getBuyPrice:(CoinbaseCompletionBlock)completion;

-(void) getBuyPriceWithQuantity:(double)qty
                       currency:(NSString *)currency
                     completion:(CoinbaseCompletionBlock)completion;

///
/// Get the sell price - Resource that tells you the total amount you can get if you sell some bitcoin.
///

-(void) getSellPrice:(CoinbaseCompletionBlock)completion;

-(void) getSellPriceWithQuantity:(double)qty
                        currency:(NSString *)currency
                      completion:(CoinbaseCompletionBlock)completion;

///
/// Get the spot price of bitcoin - Unauthenticated resource that tells you the current price of bitcoin.
///

-(void) getSpotRate:(CoinbaseCompletionBlock)completion;

-(void) getSpotRateWithCurrency:(NSString *)currency
                     completion:(CoinbaseCompletionBlock)completion;

///
/// Get the historical spot price - Unauthenticated resource that displays historical spot rates for bitcoin in USD.
///

-(void) getHistoricalSpotRate:(CoinbaseCompletionBlock)completion;

-(void) getHistoricalSpotRateWithPage:(NSUInteger)page
                           completion:(CoinbaseCompletionBlock)completion;



@end

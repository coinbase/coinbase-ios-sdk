#import <Foundation/Foundation.h>
#import "CoinbaseDefines.h"

@class CoinbasePagingHelper;
@class CoinbaseAccount;
@class CoinbaseBalance;
@class CoinbaseAddress;
@class CoinbaseMerchant;
@class CoinbaseUser;
@class CoinbaseTransaction;
@class CoinbaseTransfer;
@class CoinbaseContact;
@class CoinbaseCurrency;
@class CoinbasePaymentMethod;
@class CoinbaseAccountChange;
@class CoinbaseButton;
@class CoinbaseOrder;
@class CoinbaseAuthorization;
@class CoinbaseApplication;

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

-(void) getAccountsList:(void(^)(NSArray*, NSError*))callback;

-(void) getAccountsListWithPage:(NSUInteger)page
                          limit:(NSUInteger)limit
                    allAccounts:(BOOL)allAccounts
                     completion:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;

///
// Show an account - Authenticated resource that returns one of user’s active accounts.
//

-(void) getAccount:(NSString *)accountID completion:(void(^)(CoinbaseAccount*, NSError*))callback;

-(void) getPrimaryAccount:(void(^)(CoinbaseAccount*, NSError*))callback;

///
// Create an account - Authenticated resource that will create a new account for the user.
/// Required scope: user
//

-(void) createAccountWithName:(NSString *)name
                   completion:(void(^)(CoinbaseAccount*, NSError*))callback;

///
/// Get account’s balance - Authenticated resource that returns the user’s current account balance in BTC.
/// Required scope: balance
///

-(void) getBalanceForAccount:(NSString *)accountID completion:(void(^)(CoinbaseBalance*, NSError*))callback;

///
/// Get account’s bitcoin address - Authenticated resource that returns the user’s current bitcoin receive address. This can be used to generate scannable QR codes in the bitcoin URI format or to send the receive address to other users.
/// Required scope: address
///

-(void) getBitcoinAddressForAccount:(NSString *)accountID completion:(void(^)(CoinbaseAddress*, NSError*))callback; 

///
/// Create a new bitcoin address for an account - Authenticated resource that generates a new bitcoin receive address for the user.
/// Required scope: address
///

-(void) createBitcoinAddressForAccount:(NSString *)accountID completion:(void(^)(CoinbaseAddress*, NSError*))callback;

-(void) createBitcoinAddressForAccount:(NSString *)accountID
                                 label:(NSString *)label
                           callBackURL:(NSString *)callBackURL
                            completion:(void(^)(CoinbaseAddress*, NSError*))callback;

///
/// Modify an account
///

-(void) modifyAccount:(NSString *)accountID
                 name:(NSString *)name
           completion:(void(^)(CoinbaseAccount*, NSError*))callback;

///
/// Set account as primary - Authenticated resource that lets you set the primary status on a specific account. You must pass the :account_id of the account in the url.
///

-(void) setAccountAsPrimary:(NSString *)accountID completion:(void(^)(BOOL, NSError*))callback;

///
/// Delete an account - Authenticated resource that will delete an account. Only non-primary accounts with zero balance can be deleted.
///

-(void) deleteAccount:(NSString *)accountID completion:(void(^)(BOOL, NSError*))callback;

#pragma mark - Account Changes

///
/// List changes to an account - Authenticated resource which returns all related changes to an account. This is an alternative to the list transactions api call. It is designed to be faster and provide more detail so you can generate an overview/summary of individual account and their recent changes.
/// Required scope: transactions
///

-(void) getAccountChanges:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

-(void) getAccountChangesWithPage:(NSUInteger)page
                            limit:(NSUInteger)limit
                        accountId:(NSString *)accountId
                       completion:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

#pragma mark - Addresses

///
/// List bitcoin addresses - Authenticated resource that returns bitcoin addresses a user has associated with their account.
/// Required scope: addresses
///

-(void) getAccountAddresses:(void(^)(NSArray*, NSError*))callback;

-(void) getAccountAddressesWithPage:(NSUInteger)page
                              limit:(NSUInteger)limit
                          accountId:(NSString *)accountId
                              query:(NSString *)query
                         completion:(void(^)(NSArray*, NSError*))callback;

///
/// Show bitcoin address - Authenticated resource that returns a bitcoin address with its id or address.
/// Required scope: addresses
///

-(void) getAddressWithAddressOrID:(NSString *)addressOrID completion:(void(^)(CoinbaseAddress*, NSError*))callback;

-(void) getAddressWithAddressOrID:(NSString *)addressOrID
                        accountId:(NSString *)accountId
                       completion:(void(^)(CoinbaseAddress*, NSError*))callback;

#pragma mark - Authorization

///
/// Show authorization information - Authenticated resource that returns information about the current API authorization for user.
///

-(void) getAuthorizationInformation:(void(^)(CoinbaseAuthorization*, NSError*))callback; 


#pragma mark - Buttons

///
/// Create a new payment button, page, or iFrame - Authenticated resource that creates a payment button, page, or iFrame to accept bitcoin on your website. This can be used to accept bitcoin for an individual item or to integrate with your existing shopping cart solution. For example, you could create a new payment button for each shopping cart on your website, setting the total and order number in the button at checkout.
/// Required scope: buttons or merchant
///

-(void) createButtonWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(void(^)(CoinbaseButton*, NSError*))callback;

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
                 completion:(void(^)(CoinbaseButton*, NSError*))callback;

///
/// Show a button - Authenticated resource which lets you retrieve an individual button.
/// Required scope: buttons or merchant
///

-(void)getButtonWithID:(NSString *)customValueOrID completion:(void(^)(CoinbaseButton*, NSError*))callback;

///
/// Create an order for a button - Authenticated resource which lets you generate an order associated with a button.
/// Required scope: buttons or merchant
///

-(void) createOrderForButtonWithID:(NSString *)customValueOrID completion:(void(^)(CoinbaseOrder*, NSError*))callback;

///
/// List orders for a button - Authenticated resource which lets you obtain the orders associated with a given button.
/// Required scope: buttons or merchant
///

-(void)getOrdersForButtonWithID:(NSString *)customValueOrID completion:(void(^)(NSArray*, NSError*))callback;

#pragma mark - Buys

///
/// Buy bitcoin - Authenticated resource that lets you purchase bitcoin using a bank account that is linked to your account. You must link and verify a bank account through the website before this api call will work, otherwise error is returned.
/// Required scope: buy

-(void) buy:(NSString *)quantity completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

-(void)                 buy:(NSString *)quantity
                  accountID:(NSString *)accountID
                   currency:(NSString *)currency
       agreeBTCAmountVaries:(BOOL)agreeBTCAmountVaries
                     commit:(BOOL)commit
            paymentMethodID:(NSString *)paymentMethodID
                 completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

#pragma mark - Contacts

///
/// List emails the user has previously used for autocompletion - Authenticated resource that returns contacts the user has previously sent to or received from.
/// Required scope: contacts
///

-(void) getContacts:(void(^)(NSArray*, NSError*))callback;

-(void) getContactsWithPage:(NSUInteger)page
                      limit:(NSUInteger)limit
                      query:(NSString *)query
                 completion:(void(^)(NSArray*, NSError*))callback;

#pragma mark - Currencies

///
/// List currencies supported by Coinbase - Unauthenticated resource that returns currencies supported on Coinbase
///

-(void) getSupportedCurrencies:(void(^)(NSArray*, NSError*))callback;

///
/// List exchange rates between BTC and other currencies - Unauthenticated resource that returns BTC to fiat (and vice versus) exchange rates in various currencies.
///

-(void) getExchangeRates:(void(^)(NSDictionary*, NSError*))callback;

#pragma mark - Deposits

///
/// Deposit USD - Authenticated resource that lets you deposit USD into a USD wallet. You must have a valid USD wallet and bank account connected to use this endpoint.
/// Required scope: deposit
///

-(void) makeDepositToAccount:(NSString *)accountID
                      amount:(NSString *)amount
             paymentMethodId:(NSString *)paymentMethodId
                      commit:(BOOL)commit
                  completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

#pragma mark - Multisig

///
/// Create a multisig account - Authenticated endpoint to create accounts.
///

-(void) createMultiSigAccountWithName:(NSString *)name
                                 type:(NSString *)type
                   requiredSignatures:(NSUInteger)requiredSignatures
                             xPubKeys:(NSArray *)xPubKeys
                           completion:(void(^)(CoinbaseAccount*, NSError*))callback;

///
/// Create a multisig transaction - Authenticated resource which lets you send money to an email or bitcoin address.
/// Required scope: send
///

// Use sendAmount:to:completion: below

///
/// Get signature hashes for each input that needs signing in a spend from multisig transaction - Authenticated resource which lets you fetch signature hashes.
///

-(void) getSignatureHashesWithTransactionID:(NSString *)transactionID
                                 completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) getSignatureHashesWithTransactionID:(NSString *)transactionID
                                  accountID:(NSString *)accountID
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

-(void) signaturesForMultiSigTransaction:(NSString *)transactionID
                              signatures:(NSArray *)signatures
                              completion:(CoinbaseCompletionBlock)completion;

#pragma mark - OAuth Applications

///
/// List OAuth applications - List the OAuth applications you have created.
/// Required scope: oauth_apps
///

-(void) getOAuthApplications:(void(^)(NSArray*, NSError*))callback;

-(void) getOAuthApplicationsWithPage:(NSUInteger)page
                               limit:(NSUInteger)limit
                          completion:(void(^)(NSArray*, NSError*))callback;

///
/// Show an OAuth application - Show an individual OAuth application you have created.
/// Required scope: oauth_apps
///

-(void) getOAuthApplicationWithID:(NSString *)applicationID
                       completion:(void(^)(CoinbaseApplication*, NSError*))callback;

///
/// Create an OAuth application - Create an app that can be given access to other accounts via OAuth2.
///

-(void) createOAuthApplicationWithName:(NSString *)name
                           reDirectURL:(NSString *)reDirectURL
                            completion:(void(^)(CoinbaseApplication*, NSError*))callback;

#pragma mark - Orders

///
/// List orders - Authenticated resource which returns a merchant’s orders that they have received.
/// Required scope: orders or merchant
///

-(void) getOrders:(void(^)(NSArray*, NSError*))callback;

-(void) getOrdersWithPage:(NSUInteger)page
                    limit:(NSUInteger)limit
                accountID:(NSString *)accountID
               completion:(void(^)(NSArray*, NSError*))callback;

///
/// Create an order - Authenticated resource which returns an order for a new button.
/// Required scope: orders or merchant
///

-(void) createOrderWithName:(NSString *)name
                      price:(NSString *)price
           priceCurrencyISO:(NSString *)priceCurrencyISO
                 completion:(void(^)(CoinbaseOrder*, NSError*))callback;

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
                 completion:(void(^)(CoinbaseOrder*, NSError*))callback;

///
/// Show an order - Authenticated resource which returns order details.
/// Required scope: orders or merchant
///

-(void) getOrderWithID:(NSString *)customFieldOrID
            completion:(void(^)(CoinbaseOrder*, NSError*))callback;

-(void) getOrderWithID:(NSString *)customFieldOrID
             accountID:(NSString *)accountID
            completion:(void(^)(CoinbaseOrder*, NSError*))callback;

///
/// Refund an order - Authenticated resource which refunds an order or a mispayment to an order. Returns a snapshot of the order data, updated with refund transaction details.
/// Required scope: orders or merchant
///

-(void) refundOrderWithID:(NSString *)customFieldOrID
            refundISOCode:(NSString *)refundISOCode
               completion:(void(^)(CoinbaseOrder*, NSError*))callback;

-(void) refundOrderWithID:(NSString *)customFieldOrID
            refundISOCode:(NSString *)refundISOCode
             mispaymentID:(NSString *)mispaymentID
    externalRefundAddress:(NSString *)externalRefundAddress
               instantBuy:(BOOL)instantBuy
               completion:(void(^)(CoinbaseOrder*, NSError*))callback;

#pragma mark - Payment Methods

///
/// List payment methods - Lists all of the payment methods associated with your account
/// Required scope: buy or sell
///

-(void) getPaymentMethods:(void(^)(NSArray*, NSString*, NSString*, NSError*))callback;

///
/// Show a payment method - Lists individual payment method associated with your account.
/// Required scope: buy or sell
///

-(void) paymentMethodWithID:(NSString *)paymentMethodID completion:(void(^)(CoinbasePaymentMethod*, NSError*))callback;

#pragma mark - Prices

///
/// Get the buy price for bitcoin - Resource that tells you the total price to buy some amount of bitcoin.
///

-(void) getBuyPrice:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

-(void) getBuyPriceWithQuantity:(NSString *)quantity
                       currency:(NSString *)currency
                     completion:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

///
/// Get the sell price - Resource that tells you the total amount you can get if you sell some bitcoin.
///

-(void) getSellPrice:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

-(void) getSellPriceWithQuantity:(NSString *)quantity
                        currency:(NSString *)currency
                      completion:(void(^)(CoinbaseBalance*, NSArray*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

///
/// Get the spot price of bitcoin - Unauthenticated resource that tells you the current price of bitcoin.
///

-(void) getSpotRate:(void(^)(CoinbaseBalance*, NSError*))callback;

-(void) getSpotRateWithCurrency:(NSString *)currency
                     completion:(void(^)(CoinbaseBalance*, NSError*))callback;

///
/// Get the historical spot price - Unauthenticated resource that displays historical spot rates for bitcoin in USD.
///

-(void) getHistoricalSpotRate:(CoinbaseCompletionBlock)completion;

-(void) getHistoricalSpotRateWithPage:(NSUInteger)page
                           completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Recurring payments

///
/// List recurring payments - Authenticated resource that lets you list all your recurring payments (scheduled buys, sells, and subscriptions you’ve created with merchants).
/// Required scope: recurring_payments or merchant
///

-(void) getRecurringPayments:(CoinbaseCompletionBlock)completion;

-(void) getRecurringPaymentsWithPage:(NSUInteger)page
                               limit:(NSUInteger)limit
                          completion:(CoinbaseCompletionBlock)completion;

///
/// Show a recurring payment - Authenticated resource that lets you show an individual recurring payment.
/// Required scope: recurring_payments or merchant
///

-(void) recurringPaymentWithID:(NSString *)recurringPaymentID
                    completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Refunds

///
/// Show a refund - Authenticated resource that shows the details for a refund.
/// Required scope: merchant or orders
///

-(void) refundWithID:(NSString *)refundID
          completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Reports

///
/// List all reports - Authenticated resource which returns a list of the reports that a user has generated.
/// Required scope: reports
///

-(void) getReports:(CoinbaseCompletionBlock)completion;

-(void) getReportsWithPage:(NSUInteger)page
                     limit:(NSUInteger)limit
                completion:(CoinbaseCompletionBlock)completion;

///
/// Show a report - Authenticated resource which returns report details.
/// Required scope: reports
///

-(void) reportWithID:(NSString *)reportID completion:(CoinbaseCompletionBlock)completion;

///
/// Generate a new report - Authenticated resource which creates and returns a new CSV report
/// Required scope: reports
///

-(void) createReportWithType:(NSString *)type
                       email:(NSString *)email
                  completion:(CoinbaseCompletionBlock)completion;

-(void) createReportWithType:(NSString *)type
                       email:(NSString *)email
                   accountID:(NSString *)accountID
                 callbackURL:(NSString *)callbackURL
                   timeRange:(NSString *)timeRange
              timeRangeStart:(NSString *)timeRangeStart
                timeRangeEnd:(NSString *)timeRangeEnd
                   startType:(NSString *)startType
                 nextRunDate:(NSString *)nextRunDate
                 nextRunTime:(NSString *)nextRunTime
                      repeat:(NSString *)repeat
                       times:(NSUInteger)times
                  completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Sells

///
/// Sell bitcoin - Authenticated resource that lets you convert bitcoin in your account to fiat currency (USD, EUR) by crediting one of your bank accounts on Coinbase.
/// Required scope: sell
///

-(void) sellQuantity:(NSString *)quantity
          completion:(CoinbaseCompletionBlock)completion;

-(void) sellQuantity:(NSString *)quantity
           accountID:(NSString *)accountID
            currency:(NSString *)currency
              commit:(BOOL)commit
agreeBTCAmountVaries:(BOOL)agreeBTCAmountVaries
     paymentMethodID:(NSString *)paymentMethodID
          completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Subscriptions

///
/// List subscriptions - Authenticated resource that lets you (as a merchant) list all the subscriptions customers have made with you.
/// Required scopes: recurring_payments or merchant
///

-(void) getSubscribers:(CoinbaseCompletionBlock)completion;

-(void) getSubscribersWithAccountID:(NSString *)accountID
                         completion:(CoinbaseCompletionBlock)completion;

///
/// Show a subscription - Authenticated resource that lets you (as a merchant) show an individual subscription than a customer has created with you.
/// Required scopes: recurring_payments or merchant
///

-(void) subscriptionWithID:(NSString *)subscriptionID completion:(CoinbaseCompletionBlock)completion;

-(void) subscriptionWithID:(NSString *)subscriptionID
                 accountID:(NSString *)accountID
                completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Tokens

///
/// Create a token which can be redeemed for bitcoin - Creates tokens redeemable for bitcoin.
///

-(void) createToken:(CoinbaseCompletionBlock)completion;

///
/// Redeem a token, claiming its address and all its bitcoin - Authenticated resource which claims a redeemable token for its address and bitcoin(s).
/// Required scope: addresses
///

-(void) redeemTokenWithID:(NSString *)tokenID completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Transactions

///
/// List transactions - Authenticated resource which returns the user’s most recent transactions.
/// Required scope: transactions
///

-(void) getTransactions:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

-(void) getTransactionsWithPage:(NSUInteger)page
                          limit:(NSUInteger)limit
                      accountID:(NSString *)accountID
                     completion:(void(^)(NSArray*, CoinbaseUser*, CoinbaseBalance*, CoinbaseBalance*, NSError*))callback;

///
/// Show a transaction - Authenticated resource which returns the details of an individual transaction.
/// Required scope: transactions
///

-(void) transactionWithID:(NSString *)transactionID
               completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) transactionWithID:(NSString *)transactionID
                accountID:(NSString *)accountID
               completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

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
         accountID:(NSString *)accountID
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
         accountID:(NSString *)accountID
        completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Transfer money between accounts - Authenticated resource which lets you transfer bitcoin between authenticated user’s accounts.
/// Required scope: transfer
///

-(void) transferAmount:(NSString *)amount
                    to:(NSString *)to
            completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) transferAmount:(NSString *)amount
                    to:(NSString *)to
             accountID:(NSString *)accountID
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
            accountID:(NSString *)accountID
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

/// Currency amount

-(void) requestAmount:(NSString *)amount
    amountCurrencyISO:(NSString *)amountCurrencyISO
                 from:(NSString *)from
                notes:(NSString *)notes
            accountID:(NSString *)accountID
           completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Resend bitcoin request - Authenticated resource which lets the user resend a money request.
/// Required scope: request
///

-(void) resendRequestWithID:(NSString *)transactionID
                 completion:(void(^)(BOOL, NSError*))callback;

-(void) resendRequestWithID:(NSString *)transactionID
                  accountID:(NSString *)accountID
                 completion:(void(^)(BOOL, NSError*))callback;

///
/// Complete bitcoin request - Authenticated resource which lets the recipient of a money request complete the request by sending money to the user who requested the money.
/// Required scope: request
///

-(void) completeRequestWithID:(NSString *)transactionID
                   completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

-(void) completeRequestWithID:(NSString *)transactionID
                    accountID:(NSString *)accountID
                   completion:(void(^)(CoinbaseTransaction*, NSError*))callback;

///
/// Cancel bitcoin request - Authenticated resource which lets a user cancel a money request.
/// Required scope: request
///

-(void) cancelRequestWithID:(NSString *)transactionID
                 completion:(void(^)(BOOL, NSError*))callback;

-(void) cancelRequestWithID:(NSString *)transactionID
                  accountID:(NSString *)accountID
                 completion:(void(^)(BOOL, NSError*))callback;


#pragma mark - Transfers

///
/// List buy and sell history - Authenticated resource which returns the user’s bitcoin purchases and sells.
/// Required scope: transfers
///

-(void) getTransfers:(void(^)(NSArray*, NSError*))callback;

-(void) getTransfersWithPage:(NSUInteger)page
                       limit:(NSUInteger)limit
                   accountID:(NSString *)accountID
                  completion:(void(^)(NSArray*, NSError*))callback;

///
/// Show a transfer - Authenticated resource which returns a tranfer (a bitcoin purchase or sell).
/// Required scope: transfers
///

-(void) transferWithID:(NSString *)transferID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

-(void) transferWithID:(NSString *)transferID
             accountID:(NSString *)accountID
            completion:(void(^)(CoinbaseTransfer*, NSError*))callback;

/// Start a transfer that is in the created state - Authenticated resource which completes a transfer that is in the ‘created’ state.
/// Required scope: transfers
///

-(void) commitTransferWithID:(NSString *)transferID
                  completion:(CoinbaseCompletionBlock)completion;

-(void) commitTransferWithID:(NSString *)transferID
                   accountID:(NSString *)accountID
                  completion:(CoinbaseCompletionBlock)completion;

#pragma mark - Users

///
/// Get current user - Authenticated resource that shows the current user and their settings.
/// Required scope: user or merchant
///

-(void) getCurrentUser:(void(^)(CoinbaseUser*, NSError*))callback;

///
/// Modify current user - Authenticated resource that lets you update account settings for the current user.
///

-(void) modifyCurrentUserName:(NSString *)name
                   completion:(void(^)(CoinbaseUser*, NSError*))callback;

-(void) modifyCurrentUserNativeCurrency:(NSString *)nativeCurrency
                             completion:(void(^)(CoinbaseUser*, NSError*))callback;

-(void) modifyCurrentUserTimeZone:(NSString *)timeZone
                       completion:(void(^)(CoinbaseUser*, NSError*))callback;

-(void) modifyCurrentUserName:(NSString *)name
               nativeCurrency:(NSString *)nativeCurrency
                     timeZone:(NSString *)timeZone
                   completion:(void(^)(CoinbaseUser*, NSError*))callback;

#pragma mark - Withdrawals

///
/// Withdraw USD or EUR - Authenticated resource that lets you withdraw USD or EUR from a USD or EUR wallet.
/// Required scope: withdraw
///

-(void) withdrawAmount:(NSString *)amount
             accountID:(NSString *)accountID
       paymentMethodID:(NSString *)paymentMethodID
            completion:(CoinbaseCompletionBlock)completion;

-(void) withdrawAmount:(NSString *)amount
             accountID:(NSString *)accountID
       paymentMethodID:(NSString *)paymentMethodID
                commit:(BOOL)commit
            completion:(CoinbaseCompletionBlock)completion;


@end

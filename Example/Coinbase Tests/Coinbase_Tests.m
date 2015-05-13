//
//  Coinbase_Tests.m
//  Coinbase Tests
//
//  Created by Dai Hovey on 13/05/2015.
//  Copyright (c) 2015 Isaac Waller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Coinbase.h"
#import "CoinbaseAccount.h"
#import "CoinbaseBalance.h"
#import "CoinbaseAddress.h"
#import "CoinbaseUser.h"
#import "CoinbaseAccountChange.h"
#import "CoinbaseAuthorization.h"
#import "CoinbaseButton.h"
#import "CoinbaseOrder.h"
#import "CoinbaseTransfer.h"
#import "CoinbaseContact.h"
#import "CoinbaseCurrency.h"
#import "CoinbaseApplication.h"
#import "CoinbasePaymentMethod.h"
#import "CoinbaseRecurringPayment.h"
#import "CoinbaseRefund.h"
#import "CoinbaseReport.h"
#import "CoinbaseToken.h"

#import "Nocilla.h"

@interface Coinbase_Tests : XCTestCase

@property (nonatomic, strong) Coinbase *client;

@end

@implementation Coinbase_Tests

-(void) setUp
{
    [super setUp];

    self.client = [Coinbase coinbaseWithOAuthAccessToken:@"fake access token"];

    [[LSNocilla sharedInstance] start];
}

-(void) tearDown
{
    [[LSNocilla sharedInstance] clearStubs];
    [[LSNocilla sharedInstance] stop];

    [super tearDown];
}

- (void)testRequestType:(CoinbaseRequestType)type
                   path:(NSString *)path
             parameters:(NSDictionary *)parameters
                headers:(NSDictionary *)headers
             completion:(CoinbaseCompletionBlock)completion {

    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];

    NSString *resourceURL = [array objectAtIndex:4];

    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:resourceURL
                                                          withExtension:@"plist"];

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];

    NSString *jsonString  =  (NSString*)[dictionary objectForKey:@"JSON"];

    NSData *data = [jsonString dataUsingEncoding:NSUnicodeStringEncoding];

    id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    completion(response, nil);
}

-(NSString *) loadMockJSONFromFile
{
    NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:1];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
    [array removeObject:@""];

    NSString *resourceURL = [array objectAtIndex:5];

    NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:resourceURL
                                                          withExtension:@"plist"];

    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];

    NSString *jsonString  =  (NSString*)[dictionary objectForKey:@"JSON"];

    return jsonString;
}

- (void)test__getAccountsList
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/accounts").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAccountsList"];

    [self.client getAccountsList:^(NSArray *accounts, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(accounts, "accounts should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");
        XCTAssertTrue([accounts count] == 2);

        // Test first account
        CoinbaseAccount *primaryWallet = accounts[0];

        XCTAssertTrue([primaryWallet isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(primaryWallet.accountID, @"536a541fa9393bb3c7000023");
        XCTAssertEqualObjects(primaryWallet.name, @"My Wallet");
        XCTAssertEqualObjects(primaryWallet.balance.amount, @"50.00000000");
        XCTAssertEqualObjects(primaryWallet.balance.currency, @"BTC");
        XCTAssertEqualObjects(primaryWallet.nativeBalance.amount, @"500.12");
        XCTAssertEqualObjects(primaryWallet.nativeBalance.currency, @"USD");
        XCTAssertTrue([primaryWallet.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue(primaryWallet.primary);
        XCTAssertTrue([primaryWallet.type isEqual:@"wallet"]);
        XCTAssertTrue(primaryWallet.active);

        // Test second account
        CoinbaseAccount *secondWallet = accounts[1];

        XCTAssertTrue([secondWallet isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(secondWallet.accountID, @"536a541fa9393bb3c7000034");
        XCTAssertEqualObjects(secondWallet.name, @"Savings");
        XCTAssertEqualObjects(secondWallet.balance.amount, @"0.00000000");
        XCTAssertEqualObjects(secondWallet.balance.currency, @"BTC");
        XCTAssertEqualObjects(secondWallet.nativeBalance.amount, @"0.00");
        XCTAssertEqualObjects(secondWallet.nativeBalance.currency, @"USD");
        XCTAssertTrue([secondWallet.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertFalse(secondWallet.primary);
        XCTAssertTrue([secondWallet.type isEqual:@"vault"]);
        XCTAssertTrue(secondWallet.active);

        XCTAssertEqual(paging.currentPage, 1);
        XCTAssertEqual(paging.totalPages, 1);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getAccount
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/accounts/536a541fa9393bb3c7000023").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAccount"];

    [self.client getAccount:@"536a541fa9393bb3c7000023" completion:^(CoinbaseAccount *account, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(account, "account should not be nil");

        XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(account.accountID, @"536a541fa9393bb3c7000023");
        XCTAssertEqualObjects(account.name, @"My Wallet");
        XCTAssertEqualObjects(account.balance.amount, @"50.00000000");
        XCTAssertEqualObjects(account.balance.currency, @"BTC");
        XCTAssertEqualObjects(account.nativeBalance.amount, @"500.12");
        XCTAssertEqualObjects(account.nativeBalance.currency, @"USD");
        XCTAssertTrue([account.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue(account.primary);
        XCTAssertTrue([account.type isEqual:@"wallet"]);
        XCTAssertTrue(account.active);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getPrimaryAccount
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/accounts/primary").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getPrimaryAccount"];

    [self.client getPrimaryAccount:^(CoinbaseAccount *account, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(account, "account should not be nil");

        XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(account.accountID, @"536a541fa9393bb3c7000023");
        XCTAssertEqualObjects(account.name, @"My Wallet");
        XCTAssertEqualObjects(account.balance.amount, @"50.00000000");
        XCTAssertEqualObjects(account.balance.currency, @"BTC");
        XCTAssertEqualObjects(account.nativeBalance.amount, @"500.12");
        XCTAssertEqualObjects(account.nativeBalance.currency, @"USD");
        XCTAssertTrue([account.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue(account.primary);
        XCTAssertTrue([account.type isEqual:@"wallet"]);
        XCTAssertTrue(account.active);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__createAccountWithName
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/accounts").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createAccountWithName"];

    [self.client createAccountWithName:@"Savings Wallet" completion:^(CoinbaseAccount *account, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(account, "account should not be nil");

        XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(account.accountID, @"537cfb1146cd93b85d00001e");
        XCTAssertEqualObjects(account.name, @"Savings Wallet");
        XCTAssertEqualObjects(account.balance.amount, @"0.00000000");
        XCTAssertEqualObjects(account.balance.currency, @"BTC");
        XCTAssertEqualObjects(account.nativeBalance.amount, @"0.00");
        XCTAssertEqualObjects(account.nativeBalance.currency, @"USD");
        XCTAssertTrue([account.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertFalse(account.primary);
        XCTAssertTrue([account.type isEqual:@"wallet"]);
        XCTAssertTrue(account.active);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getBalanceForAccount
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/accounts/536a541fa9393bb3c7000034/balance").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getBalanceForAccount"];

    [self.client getBalanceForAccount:@"536a541fa9393bb3c7000034" completion:^(CoinbaseBalance *balance, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(balance, "balance should not be nil");

        XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(balance.amount, @"36.62800000");
        XCTAssertEqualObjects(balance.currency, @"BTC");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getBitcoinAddressForAccount
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/accounts/536a541fa9393bb3c7000034/address").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getBitcoinAddressForAccount"];

    [self.client getBitcoinAddressForAccount:@"536a541fa9393bb3c7000034" completion:^(CoinbaseAddress *address, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(address, "address should not be nil");

        XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
        XCTAssertEqualObjects(address.address, @"muVu2JZo8PbewBHRp6bpqFvVD87qvqEHWA");
        XCTAssertEqualObjects(address.callbackURL, @"http://example.com/callback_url");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__createBitcoinAddressForAccount
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/accounts/536a541fa9393bb3c7000034/address").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createBitcoinAddressForAccount"];

    [self.client createBitcoinAddressForAccount:@"536a541fa9393bb3c7000034" label:@"Dalmation donations" callBackURL:@"http://www.example.com/callback" completion:^(CoinbaseAddress *address, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(address, "address should not be nil");

        XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
        XCTAssertEqualObjects(address.address, @"muVu2JZo8PbewBHRp6bpqFvVD87qvqEHWA");
        XCTAssertEqualObjects(address.callbackURL, @"http://www.example.com/callback");
        XCTAssertEqualObjects(address.label, @"Dalmation donations");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__modifyAccount_name_completion
{
    stubRequest(@"PUT", @"https://coinbase.com/api/v1/accounts/53752d3e46cd93c93c00000c").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"PUT modifyAccount_name_completion"];

    [self.client modifyAccount:@"53752d3e46cd93c93c00000c" name:@"Satoshi Wallet" completion:^(CoinbaseAccount *account, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(account, "account should not be nil");

        XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(account.accountID, @"53752d3e46cd93c93c00000c");
        XCTAssertEqualObjects(account.name, @"Satoshi Wallet");
        XCTAssertEqualObjects(account.balance.amount, @"100.00");
        XCTAssertEqualObjects(account.balance.currency, @"GBP");
        XCTAssertEqualObjects(account.nativeBalance.amount, @"168.14");
        XCTAssertEqualObjects(account.nativeBalance.currency, @"USD");
        XCTAssertTrue([account.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertFalse(account.primary);
        XCTAssertTrue(account.active);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__setAccountAsPrimary
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/accounts/53752d3e46cd93c93c00000c/primary").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST setAccountAsPrimary"];

    [self.client setAccountAsPrimary:@"53752d3e46cd93c93c00000c" completion:^(BOOL success, NSError *error) {

        XCTAssertNil(error);

        XCTAssertTrue(success);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__deleteAccount
{
    stubRequest(@"DELETE", @"https://coinbase.com/api/v1/accounts/53752d3e46cd93c93c00000c").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST setAccountAsPrimary"];

    [self.client deleteAccount:@"53752d3e46cd93c93c00000c" completion:^(BOOL success, NSError *error) {

        XCTAssertNil(error);

        XCTAssertTrue(success);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}


/*



 // getAccountChanges

 - (void)test__getAccountChanges
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"account_changes" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];
 CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
 CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];

 NSArray *responseAccountChanges = [response objectForKey:@"account_changes"];

 for (NSDictionary *dictionary in responseAccountChanges)
 {
 CoinbaseAccountChange *accountChange = [[CoinbaseAccountChange alloc] initWithDictionary:dictionary];

 // XCTAssertTrue([accountChange isKindOfClass:[CoinbaseAccountChange class]]);
 }

 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];

 // XCTAssertTrue([user isKindOfClass:[CoinbaseUser class]]);
 // XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);
 // XCTAssertTrue([nativeBalance isKindOfClass:[CoinbaseBalance class]]);
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);

 }];
 }

 // getAccountAddresses

 - (void)test__getAccountAddresses
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"addresses/536a541fa9393bb3c7000034" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 NSArray *responseAddresses = [response objectForKey:@"addresses"];

 for (NSDictionary *dictionary in responseAddresses)
 {
 CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[dictionary objectForKey:@"address"]];
 // XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
 }

 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // getAddressWithAddressOrID

 - (void)test__getAddressWithAddressOrID
 {
 NSString *path = [NSString stringWithFormat:@"accounts/accounts/536a541fa9393bb3c7000034"];

 [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:[response objectForKey:@"address"]];

 // XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
 }];
 }

 // createBitcoinAddress

 - (void)test__createBitcoinAddress
 {
 [self testRequestType:CoinbaseRequestTypePost path:@"addresses" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];
 // XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
 }];
 }

 // getAuthorizationInformation

 - (void)test__getAuthorizationInformation
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"authorization" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseAuthorization *authorization = [[CoinbaseAuthorization alloc] initWithDictionary:response];
 // XCTAssertTrue([authorization isKindOfClass:[CoinbaseAuthorization class]]);
 }];
 }

 // createButtonWithName:price:priceCurrencyISO:

 -(void)test__createButtonWithName_price_priceCurrencyISO
 {
 NSDictionary *parameters = @{@"button" :
 @{@"name" : @"Test Button",
 @"price_string": @"1.23",
 @"price_currency_iso" : @"USD"}};

 [self testRequestType:CoinbaseRequestTypePost path:@"buttons" parameters:parameters headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseButton *button = [[CoinbaseButton alloc] initWithDictionary:[response objectForKey:@"button"]];
 // XCTAssertTrue([button isKindOfClass:[CoinbaseButton class]]);
 }];
 }

 // getButtonWithID

 -(void)test__getButtonWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"buttons/93865b9cae83706ae59220c013bc0afd" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseButton *button = [[CoinbaseButton alloc] initWithDictionary:[response objectForKey:@"button"]];
 // XCTAssertTrue([button isKindOfClass:[CoinbaseButton class]]);
 }];
 }

 // createOrderForButtonWithID

 -(void)test__createOrderForButtonWithID
 {
 [self testRequestType:CoinbaseRequestTypePost path:@"buttons/93865b9cae83706ae59220c013bc0afd/create_order" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }];
 }

 // getOrdersForButtonWithID

 -(void)test__getOrdersForButtonWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"buttons/93865b9cae83706ae59220c013bc0afd/orders" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 NSArray *responseOrders = [response objectForKey:@"orders"];

 for (NSDictionary *dictionary in responseOrders)
 {
 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[dictionary objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }

 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // buy

 -(void)test__buy
 {
 NSDictionary *parameters = @{ @"qty" : @"123" };

 [self testRequestType:CoinbaseRequestTypePost path:@"buys" parameters:parameters headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }];
 }


 // getContacts

 -(void)test__getContacts
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"contacts" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 NSArray *responseContacts = [response objectForKey:@"contacts"];

 for (NSDictionary *dictionary in responseContacts)
 {
 CoinbaseContact *contact = [[CoinbaseContact alloc] initWithDictionary:[dictionary objectForKey:@"contact"]];
 // XCTAssertTrue([contact isKindOfClass:[CoinbaseContact class]]);
 }

 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // getCurrencies

 -(void)test__getCurrencies
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"contacts" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 for (NSArray *array in response)
 {
 CoinbaseCurrency *currency = [[CoinbaseCurrency alloc] initWithArray:array];
 // XCTAssertTrue([currency isKindOfClass:[CoinbaseCurrency class]]);
 }
 }];
 }

 // getExchangeRates

 -(void)test__getExchangeRates
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"exchange_rates" parameters:nil headers:nil completion:^(id response, NSError *error)
 {
 // XCTAssertTrue([response isKindOfClass:[NSDictionary class]]);
 }];
 }

 // makeDepositToAccount

 -(void)test__makeDepositToAccount_amount_paymentMethodId_commit
 {
 NSDictionary *parameters = @{
 @"account_id" : @"54e649216291227bd200006a",
 @"amount" : @"10.00",
 @"payment_method_id" : @"54e6495e6291227bd2000078",
 @"commit" : @"false",
 };

 [self testRequestType:CoinbaseRequestTypeGet path:@"deposits" parameters:parameters headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }];
 }

 // createMultiSigAccountWithName

 -(void)test__createMultiSigAccountWithName_type_requiredSignatures_xPubKeys
 {
 NSDictionary *parameters = @{@"account" :
 @{@"name" : @"Multisig Wallet",
 @"type": @"multisig",
 @"m" : @2,
 @"xpubkeys": @[@"xpub661MyMwAqRbcFo8WEPnst2sE8MTLe9DszR7eYhtkVuiUskpAggETvYQeSBWTuwoxZrZvf18w75AzfjLhzihWGagvcMa4J9nDWjmiD2UrAEF",@"xpub661MyMwAqRbcEezXDATCwfxbet7ZYA8cyfh2FDckA85S5Tg5NjzjnPeikzJgj2noBvxTEPNkMwq8RMCuBhiL7sRv29ZtMft2KbKwTcc48uu",@"xpub661MyMwAqRbcEnKbXcCqD2GT1di5zQxVqoHPAgHNe8dv5JP8gWmDproS6kFHJnLZd23tWevhdn4urGJ6b264DfTGKr8zjmYDjyDTi9U7iyT"]}};

 [self testRequestType:CoinbaseRequestTypeGet path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error)
 {
 CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];
 // XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
 }];
 }

 // getSignatureHashesWithTransactionID

 - (void)test__getSignatureHashesWithTransactionID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"transactions/53f3d9e0cbf034354a000132/sighashes" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);

 }];
 }

 // signaturesForMultiSigTransaction

 -(void)test__signaturesForMultiSigTransaction
 {
 NSDictionary *parameters = @{
 @"signatures": @[@{
 @"position": @1,
 @"signatures": @[@"304502206f73b2147662c70fb6a951e6ddca79ce1e800a799be543d13c9d22817affb997022100b32a96c20a514783cc5135dde9a8a9608b0b55b6c0db01d553c77c544034274d",@"304502204930529e97c2c75bbc3b07a365cf691f5bf319bf0a54980785bb525bd996cb1a022100a7e9e3728444a39c7a45822c3c773a43a888432dfe767ea17e1fab8ac2bfc83f"]}]
 };

 [self testRequestType:CoinbaseRequestTypePut path:@"transactions/53f3d9e0cbf034354a000132/signatures" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 // getOAuthApplications

 -(void)test__getOAuthApplications
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"oauth/applications" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseApplications = [response objectForKey:@"applications"];

 for (NSDictionary *dictionary in responseApplications)
 {
 CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:dictionary];
 // XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);
 }

 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // getOAuthApplicationWithID

 -(void) test__getOAuthApplicationWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"oauth/applications/52fe8cf2137f733087000002" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:[response objectForKey:@"application"]];
 // XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);
 }];
 }

 // createOAuthApplicationWithName

 -(void) test__createOAuthApplicationWithName_reDirectURL
 {
 NSDictionary *parameters = @{@"application" :
 @{@"name" : @"Test app",
 @"redirect_uri": @"http://example.com/callback"
 }
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"oauth/applications" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseApplication *application = [[CoinbaseApplication alloc] initWithDictionary:[response objectForKey:@"application"]];
 // XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);
 }];
 }

 -(void) test__getOrders
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"orders" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseOrders = [response objectForKey:@"orders"];

 for (NSDictionary *dictionary in responseOrders)
 {
 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[dictionary objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 -(void)test__createOrderWithName
 {
 NSDictionary *parameters = @{@"button" :
 @{@"name" : @"test",
 @"price_string": @"1.23",
 @"price_currency_iso" : @"USD"
 }
 };

 [self testRequestType:CoinbaseRequestTypeGet path:@"orders" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }];
 }

 // getOrderWithID

 -(void) test__getOrderWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"orders/A7C52JQT" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }];
 }

 -(void) test__refundOrderWithID_refundISOCode
 {
 NSDictionary *parameters = @{
 @"refund_iso_code" : @"BTC"
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"orders/A7C52JQT/refund" parameters:parameters headers:nil completion:^(id response, NSError *error) {
 CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[response objectForKey:@"order"]];
 // XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
 }];
 }

 // getPaymentMethods

 -(void) test__getPaymentMethods
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"payment_methods" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSString *defaultBuy = [response objectForKey:@"default_buy"];
 NSString *defaultSell = [response objectForKey:@"default_sell"];

 NSArray *responsePaymentMethods = [response objectForKey:@"payment_methods"];

 for (NSDictionary *dictionary in responsePaymentMethods)
 {
 CoinbasePaymentMethod *paymentMethod = [[CoinbasePaymentMethod alloc] initWithDictionary:[dictionary objectForKey:@"payment_method"] ];
 // XCTAssertTrue([paymentMethod isKindOfClass:[CoinbasePaymentMethod class]]);
 }
 }];
 }

 // paymentMethodWithID

 -(void) test__paymentMethodWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"payment_methods/530eb5b217cb34e07a000011" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbasePaymentMethod *paymentMethod = [[CoinbasePaymentMethod alloc] initWithDictionary:[response objectForKey:@"payment_method"]];
 // XCTAssertTrue([paymentMethod isKindOfClass:[CoinbasePaymentMethod class]]);
 }];
 }

 // getBuyPrice

 -(void) test__getBuyPrice
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"prices/buy" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
 // XCTAssertTrue([btc isKindOfClass:[CoinbaseBalance class]]);

 NSArray *fees = [response objectForKey:@"fees"];

 CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
 // XCTAssertTrue([subtotal isKindOfClass:[CoinbaseBalance class]]);

 CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];
 // XCTAssertTrue([total isKindOfClass:[CoinbaseBalance class]]);
 }];
 }

 // getSellPrice

 -(void) test__getSellPrice
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"prices/sell" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseBalance *btc = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"btc"]];
 // XCTAssertTrue([btc isKindOfClass:[CoinbaseBalance class]]);

 NSArray *fees = [response objectForKey:@"fees"];
 CoinbaseBalance *subtotal = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"subtotal"]];
 // XCTAssertTrue([subtotal isKindOfClass:[CoinbaseBalance class]]);

 CoinbaseBalance *total = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"total"]];
 // XCTAssertTrue([total isKindOfClass:[CoinbaseBalance class]]);
 }];
 }

 // getSpotRate

 -(void) test__getSpotRate
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"prices/spot_rate" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];
 // XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);
 }];
 }

 // getRecurringPayments

 -(void) test__getRecurringPayments
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"recurring_payments" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

 for (NSDictionary *dictionary in responseRecurringPayments)
 {
 CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
 // XCTAssertTrue([recurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // recurringPaymentWithID

 -(void) test__recurringPaymentWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"recurring_payments/5193377ef8182b7c19000015" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[response objectForKey:@"recurring_payment"]];
 // XCTAssertTrue([recurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
 }];
 }

 -(void) test__refundWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"refunds/54d19395ef634f53d400009a" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseRefund *refund = [[CoinbaseRefund alloc] initWithDictionary:[response objectForKey:@"refund"]];
 // XCTAssertTrue([refund isKindOfClass:[CoinbaseRefund class]]);

 }];
 }

 -(void) test__getReports
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"reports" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseReports = [response objectForKey:@"reports"];

 for (NSDictionary *dictionary in responseReports)
 {
 CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[dictionary objectForKey:@"report"]];
 // XCTAssertTrue([report isKindOfClass:[CoinbaseReport class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 -(void) test__reportWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"reports/533e5de1137f73ccf1000139" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[response objectForKey:@"report"]];
 // XCTAssertTrue([report isKindOfClass:[CoinbaseReport class]]);
 }];
 }

 -(void) test__createReportWithType_email
 {
 NSDictionary *parameters = @{@"report" :
 @{@"type" : @"transactions",
 @"email": @"dummy@example.com",
 }
 };
 [self testRequestType:CoinbaseRequestTypePost path:@"reports" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseReport *report = [[CoinbaseReport alloc] initWithDictionary:[response objectForKey:@"report"]];
 // XCTAssertTrue([report isKindOfClass:[CoinbaseReport class]]);
 }];
 }

 -(void) test__sellQuantity
 {
 NSDictionary *parameters = @{
 @"qty" : @"123"
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"sells" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }];
 }

 -(void) test__getSubscribers
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"subscribers" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseRecurringPayments = [response objectForKey:@"recurring_payments"];

 for (NSDictionary *dictionary in responseRecurringPayments)
 {
 CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[dictionary objectForKey:@"recurring_payment"]];
 // XCTAssertTrue([recurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 // subscriptionWithID

 -(void) test__subscriptionWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"subscribers/51a7cf58f8182b4b220000d5" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseRecurringPayment *recurringPayment = [[CoinbaseRecurringPayment alloc] initWithDictionary:[response objectForKey:@"recurring_payment"]];
 // XCTAssertTrue([recurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);

 }];
 }

 -(void) test__createToken
 {
 [self testRequestType:CoinbaseRequestTypePost path:@"tokens" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseToken *token = [[CoinbaseToken alloc] initWithDictionary:[response objectForKey:@"token"]];
 // XCTAssertTrue([token isKindOfClass:[CoinbaseToken class]]);
 }];
 }

 -(void) test__redeemTokenWithID
 {
 NSDictionary *parameters = @{
 @"token_id" : @"abc12e821cf6e128afc2e821cf68e12cf68e168e128af21cf682e821cf68e1fe"
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"tokens/redeem" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 BOOL success = [[response objectForKey:@"success"] boolValue];
 // XCTAssertTrue([success);
 }];
 }

 -(void) test__getTransactions
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"transactions" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"balance"]];
 // XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);

 CoinbaseBalance *nativeBalance = [[CoinbaseBalance alloc] initWithDictionary:[response objectForKey:@"native_balance"]];
 // XCTAssertTrue([nativeBalance isKindOfClass:[CoinbaseBalance class]]);

 CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"current_user"]];
 // XCTAssertTrue([user isKindOfClass:[CoinbaseUser class]]);

 NSArray *responseTransactions = [response objectForKey:@"transactions"];

 for (NSDictionary *dictionary in responseTransactions)
 {
 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[dictionary objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 -(void) test__transactionWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"transactions/5018f833f8182b129c00002f" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 -(void) test__sendAmount_to
 {
 NSDictionary *parameters = @{@"transaction" :
 @{@"to" : @"to@example.com",
 @"amount": @"123"
 }
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"transactions/send_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 -(void) test__transferAmount_to
 {
 NSDictionary *parameters = @{@"transaction" :
 @{@"to" : @"to@example.com",
 @"amount": @"123"
 }
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"transactions/transfer_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 -(void) test__requestAmount_from
 {
 NSDictionary *parameters = @{@"transaction" :
 @{@"from" : @"from@example.com",
 @"amount": @"123"
 }
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"transactions/request_money" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 -(void) test__resendRequestWithID
 {
 [self testRequestType:CoinbaseRequestTypePut path:@"transactions/501a3554f8182b2754000003/resend_request" parameters:nil headers:nil completion:^(id response, NSError *error) {

 BOOL success = [[response objectForKey:@"success"] boolValue];
 // XCTAssertTrue(success);
 }];
 }

 -(void) test__completeRequestWithID
 {
 [self testRequestType:CoinbaseRequestTypePut path:@"transactions/501a3554f8182b2754000003/complete_request" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransaction *transaction = [[CoinbaseTransaction alloc] initWithDictionary:[response objectForKey:@"transaction"]];
 // XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);
 }];
 }

 -(void) test__cancelRequestWithID
 {
 [self testRequestType:CoinbaseRequestTypePut path:@"transactions/501a3554f8182b2754000003/cancel_request" parameters:nil headers:nil completion:^(id response, NSError *error) {

 BOOL success = [[response objectForKey:@"success"] boolValue];
 // XCTAssertTrue(success);
 }];
 }

 -(void) test__getTransfers
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"transfers" parameters:nil headers:nil completion:^(id response, NSError *error) {

 NSArray *responseTransfers = [response objectForKey:@"transfers"];

 for (NSDictionary *dictionary in responseTransfers)
 {
 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[dictionary objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }
 CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
 // XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
 }];
 }

 -(void) test__transferWithID
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"transfers/544047e346cd9333bd000066" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }];
 }

 -(void) test__commitTransferWithID
 {
 [self testRequestType:CoinbaseRequestTypePost path:@"transfers/5474d23a629122e172000238/commit" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);

 }];
 }

 -(void) test__getCurrentUser
 {
 [self testRequestType:CoinbaseRequestTypeGet path:@"users/self" parameters:nil headers:nil completion:^(id response, NSError *error) {

 CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
 // XCTAssertTrue([user isKindOfClass:[CoinbaseUser class]]);

 }];
 }

 -(void) test__modifyCurrentUserName
 {
 NSDictionary *parameters = @{@"user" :
 @{@"name" : @"Satoshi",
 }
 };

 [self testRequestType:CoinbaseRequestTypePut path:@"users/self" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseUser *user = [[CoinbaseUser alloc] initWithDictionary:[response objectForKey:@"user"]];
 // XCTAssertTrue([user isKindOfClass:[CoinbaseUser class]]);
 }];
 }

 -(void) test__withdrawAmount_accountID_paymentMethodID
 {
 NSDictionary *parameters = @{
 @"amount" : @"54e649216291227bd200006a",
 @"payment_method_id" : @"54e649216291227bd200006a",
 @"account_id" : @"10.0"
 };

 [self testRequestType:CoinbaseRequestTypePost path:@"withdrawals" parameters:parameters headers:nil completion:^(id response, NSError *error) {

 CoinbaseTransfer *transfer = [[CoinbaseTransfer alloc] initWithDictionary:[response objectForKey:@"transfer"]];
 // XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);
 }];
 }
 */

@end



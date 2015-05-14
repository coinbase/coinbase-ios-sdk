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

- (void)test__getAccountChanges
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/account_changes").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"PUT modifyAccount_name_completion"];

    [self.client getAccountChanges:^(NSArray *accountChanges, CoinbaseUser *user, CoinbaseBalance *balance, CoinbaseBalance *nativeBalance, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(accountChanges, "accountChanges should not be nil");
        XCTAssertNotNil(user, "user should not be nil");
        XCTAssertNotNil(balance, "balance should not be nil");
        XCTAssertNotNil(nativeBalance, "nativeBalance should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");
        XCTAssertTrue([accountChanges count] == 1);

        CoinbaseAccountChange *accountChange = accountChanges[0];

        XCTAssertTrue([accountChange isKindOfClass:[CoinbaseAccountChange class]]);
        XCTAssertEqualObjects(accountChange.accountChangesID, @"524a75a3f8182b7d2a000018");
        XCTAssertEqualObjects(accountChange.transactionID, @"524a75a3f8182b7d2a000010");
        XCTAssertFalse(accountChange.confirmed);
        XCTAssertEqualObjects(accountChange.amount.amount, @"50.00000000");
        XCTAssertEqualObjects(accountChange.amount.currency, @"BTC");

        XCTAssertFalse(accountChange.notesPresent);
        XCTAssertEqualObjects(accountChange.category, @"tx");
        XCTAssertEqualObjects(accountChange.otherUserName, @"an external account");

        XCTAssertEqualObjects(user.userID, @"524a75a3f8182b7d2a00000a");
        XCTAssertEqualObjects(user.email, @"user2@example.com");
        XCTAssertEqualObjects(user.name, @"User 2");

        XCTAssertEqualObjects(balance.amount, @"50.00000000");
        XCTAssertEqualObjects(balance.currency, @"BTC");

        XCTAssertEqualObjects(nativeBalance.amount, @"500.00");
        XCTAssertEqualObjects(nativeBalance.currency, @"USD");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getAccountAddresses
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/addresses").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAccountAddresses"];

    [self.client getAccountAddresses:^(NSArray *addresses, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(addresses, "addresses should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");
        XCTAssertTrue([addresses count] == 3);

        CoinbaseAddress *firstAddress = addresses[0];

        XCTAssertTrue([firstAddress isKindOfClass:[CoinbaseAddress class]]);
        XCTAssertEqualObjects(firstAddress.address, @"moLxGrqWNcnGq4A8Caq8EGP4n9GUGWanj4");
        XCTAssertEqualObjects(firstAddress.callbackURL, [NSNull null]);
        XCTAssertEqualObjects(firstAddress.label, @"My Label");
        XCTAssertTrue([firstAddress.creationDate isKindOfClass:[NSDate class]]);

        CoinbaseAddress *lastAddress = addresses[2];

        XCTAssertTrue([lastAddress isKindOfClass:[CoinbaseAddress class]]);
        XCTAssertEqualObjects(lastAddress.address, @"2N139JFn7dwX1ySkdWYDXCV51oyBCuV8zYw");
        XCTAssertEqualObjects(lastAddress.callbackURL, [NSNull null]);
        XCTAssertEqualObjects(lastAddress.label, [NSNull null]);
        XCTAssertTrue([lastAddress.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(lastAddress.type, @"p2sh");
        XCTAssertEqualObjects(lastAddress.redeemScript, @"524104c6e3f151b7d0ca7a63c6090c1eb86fd2cbfce43c367b5b36553ba28ade342b9dd8590f48abd48aa0160babcabfdccc6529609d2f295b3165e724de2f15adca9d410434cca255243e36de58f628b0f462518168b9c97b408f92ea9e01e168c70c003398bbf9b4c5cb9344f00c7cebf40322405f9b063eb4d2da25e710759aa51301eb4104624c024547a858b898bfe0b89c4281d743303da6d9ad5fc2f82228255586a9093011a540acae4bdf77ce427c0cb9b482918093e677238800fc0f6fae14f6712853ae");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getAddressWithAddressOrID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/addresses/503c46a4f8182b10650000ad").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAddressWithAddressOrID"];

    [self.client getAddressWithAddressOrID:@"503c46a4f8182b10650000ad" completion:^(CoinbaseAddress *address, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(address, "address should not be nil");

        XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
        XCTAssertEqualObjects(address.addressID, @"503c46a4f8182b10650000ad");
        XCTAssertEqualObjects(address.address, @"moLxGrqWNcnGq4A8Caq8EGP4n9GUGWanj4");
        XCTAssertEqualObjects(address.callbackURL, [NSNull null]);
        XCTAssertEqualObjects(address.label, @"My Label");
        XCTAssertTrue([address.creationDate isKindOfClass:[NSDate class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__createBitcoinAddress
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/addresses").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createBitcoinAddress"];

    [self.client createBitcoinAddressForAccount:@"" label:@"Dalmation donations" callBackURL:@"http://www.example.com/callback" completion:^(CoinbaseAddress *address, NSError *error) {

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

- (void)test__getAuthorizationInformation
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/authorization").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAuthorizationInformation"];

    [self.client getAuthorizationInformation:^(CoinbaseAuthorization *authorization, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(authorization, "authorization should not be nil");

        XCTAssertTrue([authorization isKindOfClass:[CoinbaseAuthorization class]]);
        XCTAssertEqualObjects(authorization.authType, @"oauth");
        XCTAssertEqualObjects(authorization.sendLimitPeriod, @"month");
        XCTAssertEqualObjects(authorization.sendLimitCurrency, @"USD");
        XCTAssertEqualObjects(authorization.sendLimitAmount, @"500");
        XCTAssertTrue([authorization.scopes isKindOfClass:[NSArray class]]);
        XCTAssertEqualObjects(authorization.scopes[0], @"user");
        XCTAssertEqualObjects(authorization.scopes[1], @"balance");
        XCTAssertEqualObjects(authorization.scopes[2], @"send");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__createButtonWithName_price_priceCurrencyISO
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/buttons").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createButtonWithName_price_priceCurrencyISO"];

    [self.client createButtonWithName:@"test"
                                price:@"1.23"
                     priceCurrencyISO:@"USD"
                            accountID:nil
                                 type:@"buy_now"
                         subscription:NO
                               repeat:nil
                                style:@"custom_large"
                                 text:nil
                          description:@"Sample description"
                               custom:@"Order123"
                         customSecure:NO
                          callbackURL:@"http://www.example.com/my_custom_button_callback"
                           successURL:nil
                            cancelURL:nil
                              infoURL:nil
                         autoRedirect:NO
                  autoRedirectSuccess:NO
                   autoRedirectCancel:NO
                        variablePrice:NO
                       includeAddress:NO
                         includeEmail:YES
                          choosePrice:NO
                               price1:nil
                               price2:nil
                               price3:nil
                               price4:nil
                               price5:nil
                           completion:^(CoinbaseButton *button, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(button, "button should not be nil");

        XCTAssertTrue([button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(button.code, @"93865b9cae83706ae59220c013bc0afd");
        XCTAssertEqualObjects(button.type, @"buy_now");
        XCTAssertFalse(button.subscription);
        XCTAssertEqualObjects(button.style, @"custom_large");
        XCTAssertEqualObjects(button.text, @"Pay With Bitcoin");
        XCTAssertEqualObjects(button.name, @"test");
        XCTAssertEqualObjects(button.buttonDescription, @"Sample description");
        XCTAssertEqualObjects(button.custom, @"Order123");
        XCTAssertEqualObjects(button.callbackURL, @"http://www.example.com/my_custom_button_callback");
        XCTAssertTrue([button.price isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(button.price.cents, @"123");
        XCTAssertEqualObjects(button.price.currencyISO, @"USD");
      
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getButtonWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/buttons/93865b9cae83706ae59220c013bc0afd").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getAuthorizationInformation"];

    [self.client getButtonWithID:@"93865b9cae83706ae59220c013bc0afd" completion:^(CoinbaseButton *button, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(button, "button should not be nil");

        XCTAssertTrue([button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(button.code, @"93865b9cae83706ae59220c013bc0afd");
        XCTAssertEqualObjects(button.type, @"buy_now");
        XCTAssertFalse(button.subscription);
        XCTAssertEqualObjects(button.style, @"custom_large");
        XCTAssertEqualObjects(button.text, @"Pay With Bitcoin");
        XCTAssertEqualObjects(button.name, @"test");
        XCTAssertEqualObjects(button.buttonDescription, @"Sample description");
        XCTAssertEqualObjects(button.custom, @"Order123");
        XCTAssertEqualObjects(button.callbackURL, @"http://www.example.com/my_custom_button_callback");
        XCTAssertTrue([button.price isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(button.price.cents, @"123");
        XCTAssertEqualObjects(button.price.currencyISO, @"USD");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__createOrderForButtonWithID
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/buttons/93865b9cae83706ae59220c013bc0afd/create_order").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createOrderForButtonWithID"];

    [self.client createOrderForButtonWithID:@"93865b9cae83706ae59220c013bc0afd" completion:^(CoinbaseOrder *order, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(order, "order should not be nil");

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"7RTTRDVP");
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"100000000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"3000");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"USD");
        XCTAssertEqualObjects(order.status, @"new");
        XCTAssertEqualObjects(order.custom, @"Order123");
        XCTAssertEqualObjects(order.receiveAddress, @"mgrmKftH5CeuFBU3THLWuTNKaZoCGJU5jQ");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"test");
        XCTAssertEqualObjects(order.button.buttonDescription, @"Sample description");
        XCTAssertEqualObjects(order.button.buttonID, @"93865b9cae83706ae59220c013bc0afd");
        XCTAssertEqualObjects(order.transaction, nil);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getOrdersForButtonWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/buttons/93865b9cae83706ae59220c013bc0afd/orders").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOrdersForButtonWithID"];

    [self.client getOrdersForButtonWithID:@"93865b9cae83706ae59220c013bc0afd" completion:^(NSArray *orders, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(orders, "orders should not be nil");

        CoinbaseOrder *order = [orders objectAtIndex:0];

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"7RTTRDVP");
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"100000000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"100000000");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"BTC");
        XCTAssertEqualObjects(order.status, @"new");
        XCTAssertEqualObjects(order.custom, @"Order123");
        XCTAssertEqualObjects(order.receiveAddress, @"mgrmKftH5CeuFBU3THLWuTNKaZoCGJU5jQ");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"test");
        XCTAssertEqualObjects(order.button.buttonDescription, @"Sample description");
        XCTAssertEqualObjects(order.button.buttonID, @"93865b9cae83706ae59220c013bc0afd");
        XCTAssertEqualObjects(order.transaction, nil);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__buy
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/buys").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST buy"];

    [self.client buy:@"1" completion:^(CoinbaseTransfer *transfer, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(transfer, "transfer should not be nil");

        XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);

        XCTAssertEqualObjects(transfer.transferID, @"5456c2cb46cd93593d00000b");
        XCTAssertEqualObjects(transfer.type, @"Buy");
        XCTAssertEqualObjects(transfer.code, @"5456c2cb46cd93593d00000b");
        XCTAssertTrue([transfer.coinbaseFees isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(transfer.coinbaseFees.cents, @"14");
        XCTAssertEqualObjects(transfer.coinbaseFees.currencyISO, @"USD");
        XCTAssertTrue([transfer.bankFees isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(transfer.bankFees.cents, @"15");
        XCTAssertEqualObjects(transfer.bankFees.currencyISO, @"USD");
        XCTAssertEqualObjects(transfer.status, @"Created");

        XCTAssertTrue([transfer.bitcoinAmount isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.bitcoinAmount.amount, @"1.00000000");
        XCTAssertEqualObjects(transfer.bitcoinAmount.currency, @"BTC");
        XCTAssertTrue([transfer.subTotal isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.subTotal.amount, @"13.55");
        XCTAssertEqualObjects(transfer.subTotal.currency, @"USD");
        XCTAssertTrue([transfer.total isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.total.amount, @"13.84");
        XCTAssertEqualObjects(transfer.total.currency, @"USD");

        XCTAssertTrue([transfer.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([transfer.payoutDate isKindOfClass:[NSDate class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getContacts
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/contacts").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getContacts"];

    [self.client getContacts:^(NSArray *contacts, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(contacts, "contacts should not be nil");
        XCTAssertTrue([contacts count] == 2);

        CoinbaseContact *firstContact = [contacts objectAtIndex:0];

        XCTAssertTrue([firstContact isKindOfClass:[CoinbaseContact class]]);
        XCTAssertEqualObjects(firstContact.email, @"user1@example.com");

        CoinbaseContact *secondContact = [contacts objectAtIndex:1];

        XCTAssertTrue([secondContact isKindOfClass:[CoinbaseContact class]]);
        XCTAssertEqualObjects(secondContact.email, @"user2@example.com");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getCurrencies
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/currencies").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getCurrencies"];

    [self.client getSupportedCurrencies:^(NSArray *currencies, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(currencies, "currencies should not be nil");
        XCTAssertTrue([currencies count] == 4);

        CoinbaseCurrency *firstCurrency = [currencies objectAtIndex:0];

        XCTAssertTrue([firstCurrency isKindOfClass:[CoinbaseCurrency class]]);
        XCTAssertEqualObjects(firstCurrency.name, @"Afghan Afghani (AFN)");
        XCTAssertEqualObjects(firstCurrency.iso, @"AFN");

        CoinbaseCurrency *lastCurrency = [currencies objectAtIndex:3];

        XCTAssertTrue([lastCurrency isKindOfClass:[CoinbaseCurrency class]]);
        XCTAssertEqualObjects(lastCurrency.name, @"Zimbabwean Dollar (ZWL)");
        XCTAssertEqualObjects(lastCurrency.iso, @"ZWL");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getExchangeRates
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/currencies/exchange_rates").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getExchangeRates"];

    [self.client getExchangeRates:^(NSDictionary *exchangeRates, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(exchangeRates, "exchangeRates should not be nil");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__makeDepositToAccount_amount_paymentMethodId_commit
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/deposits").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST makeDepositToAccount_amount_paymentMethodId_commit"];

    [self.client makeDepositToAccount:@"54e649216291227bd200006a"
                               amount:@"10.00" paymentMethodId:@"54e6495e6291227bd2000078"
                               commit:YES
                           completion:^(CoinbaseTransfer *transfer, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(transfer, "transfer should not be nil");

        XCTAssertTrue([transfer isKindOfClass:[CoinbaseTransfer class]]);

        XCTAssertEqualObjects(transfer.transferID, @"54e66f226291227bd20000c4");

        XCTAssertEqualObjects(transfer.type, @"Deposit");
        XCTAssertEqualObjects(transfer.code, @"54e66f226291227bd20000c4");

        XCTAssertTrue([transfer.bankFees isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(transfer.bankFees.cents, @"0");
        XCTAssertEqualObjects(transfer.bankFees.currencyISO, @"USD");

        XCTAssertEqualObjects(transfer.transactionID, @"54e66f236291227bd20000c9");
        XCTAssertEqualObjects(transfer.status, @"Pending");
        XCTAssertEqualObjects(transfer.detailedStatus, @"started");

        XCTAssertTrue([transfer.bitcoinAmount isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.bitcoinAmount.amount, @"0.00000000");
        XCTAssertEqualObjects(transfer.bitcoinAmount.currency, @"BTC");
        XCTAssertTrue([transfer.subTotal isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.subTotal.amount, @"10.00");
        XCTAssertEqualObjects(transfer.subTotal.currency, @"USD");
        XCTAssertTrue([transfer.total isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(transfer.total.amount, @"10.00");
        XCTAssertEqualObjects(transfer.total.currency, @"USD");

        XCTAssertEqualObjects(transfer.transferDescription, @"Deposited $10.00 via *****7978.");
        XCTAssertEqualObjects(transfer.accountID, @"54e649216291227bd200006a");
        XCTAssertEqualObjects(transfer.paymentMethod.paymentMethodID, @"54e6495e6291227bd2000078");
        XCTAssertEqualObjects(transfer.paymentMethod.currency, @"USD");
        XCTAssertEqualObjects(transfer.paymentMethod.name, @" *****7978");
        XCTAssertTrue(transfer.paymentMethod.canBuy);
        XCTAssertTrue(transfer.paymentMethod.canSell);
        XCTAssertTrue(transfer.paymentMethod.verified);
        XCTAssertEqualObjects(transfer.paymentMethod.type, @"ach_bank_account");

        XCTAssertTrue([transfer.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([transfer.payoutDate isKindOfClass:[NSDate class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__createMultiSigAccountWithName_type_requiredSignatures_xPubKeys
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/accounts").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST getAccountsList"];

    [self.client createMultiSigAccountWithName:@"Multisig Wallet"
                                          type:@"multisig"
                            requiredSignatures:2 xPubKeys:@[
@"xpub661MyMwAqRbcFo8WEPnst2sE8MTLe9DszR7eYhtkVuiUskpAggETvYQeSBWTuwoxZrZvf18w75AzfjLhzihWGagvcMa4J9nDWjmiD2UrAEF",
@"xpub661MyMwAqRbcEezXDATCwfxbet7ZYA8cyfh2FDckA85S5Tg5NjzjnPeikzJgj2noBvxTEPNkMwq8RMCuBhiL7sRv29ZtMft2KbKwTcc48uu",
@"xpub661MyMwAqRbcEnKbXcCqD2GT1di5zQxVqoHPAgHNe8dv5JP8gWmDproS6kFHJnLZd23tWevhdn4urGJ6b264DfTGKr8zjmYDjyDTi9U7iyT"
                                                           ]
                                    completion:^(CoinbaseAccount *account, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(account, "account should not be nil");

        XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        XCTAssertEqualObjects(account.accountID, @"53f3d34bcbf034354a00005a");
        XCTAssertEqualObjects(account.name, @"Multisig Wallet");
        XCTAssertEqualObjects(account.balance.amount, @"0.00000000");
        XCTAssertEqualObjects(account.balance.currency, @"BTC");
        XCTAssertEqualObjects(account.nativeBalance.amount, @"0.00");
        XCTAssertEqualObjects(account.nativeBalance.currency, @"USD");
        XCTAssertTrue([account.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertFalse(account.primary);
        XCTAssertTrue([account.type isEqual:@"multisig_vault"]);
        XCTAssertTrue(account.active);
        XCTAssertEqualObjects(account.m, @"2");
        XCTAssertEqualObjects(account.n, @"3");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

- (void)test__getSignatureHashesWithTransactionID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/transactions/53f3d9e0cbf034354a000132/sighashes").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getSignatureHashesWithTransactionID"];

    [self.client getSignatureHashesWithTransactionID:@"53f3d9e0cbf034354a000132" completion:^(CoinbaseTransaction *transaction, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(transaction, "transaction should not be nil");

        XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);

        XCTAssertEqualObjects(transaction.transactionID, @"53f3d9e0cbf034354a000132");
        XCTAssertTrue([transaction.inputArray isKindOfClass:[NSArray class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__signaturesForMultiSigTransaction
{
    stubRequest(@"PUT", @"https://coinbase.com/api/v1/transactions/53f3d9e0cbf034354a000132/signatures").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"PUT signaturesForMultiSigTransaction"];

    [self.client signaturesForMultiSigTransaction:@"53f3d9e0cbf034354a000132"
                                       signatures:@[@"304502206f73b2147662c70fb6a951e6ddca79ce1e800a799be543d13c9d22817affb997022100b32a96c20a514783cc5135dde9a8a9608b0b55b6c0db01d553c77c544034274d",@"304502204930529e97c2c75bbc3b07a365cf691f5bf319bf0a54980785bb525bd996cb1a022100a7e9e3728444a39c7a45822c3c773a43a888432dfe767ea17e1fab8ac2bfc83f"
                                                                                           ]
                                       completion:^(CoinbaseTransaction *transaction, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(transaction, "transaction should not be nil");

        XCTAssertTrue([transaction isKindOfClass:[CoinbaseTransaction class]]);

        XCTAssertEqualObjects(transaction.transactionID, @"53f3d9e0cbf034354a000132");
        XCTAssertTrue([transaction.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(transaction.hashString, @"bb9199a339e79556be6f9935e12bb189eeaa74bdc7d9bc18191f5a504c840230");
        XCTAssertEqualObjects(transaction.amount.amount, @"0.10000000");
        XCTAssertEqualObjects(transaction.amount.currency, @"BTC");
        XCTAssertFalse(transaction.request);
        XCTAssertEqualObjects(transaction.status, @"pending");
        XCTAssertTrue([transaction.sender isKindOfClass:[CoinbaseUser class]]);
        XCTAssertEqualObjects(transaction.sender.userID, @"52f1b613137f736761000001");
        XCTAssertEqualObjects(transaction.sender.email, @"user1@example.com");
        XCTAssertEqualObjects(transaction.sender.name, @"User One");
        XCTAssertTrue([transaction.recipient isKindOfClass:[CoinbaseUser class]]);
        XCTAssertEqualObjects(transaction.recipient.userID, @"52f1b61a137f7367610000a6");
        XCTAssertEqualObjects(transaction.recipient.email, @"user2@example.com");
        XCTAssertEqualObjects(transaction.recipient.name, @"User Two");
        XCTAssertEqualObjects(transaction.recipientAddress, @"user2@example.com");
        XCTAssertEqualObjects(transaction.notes, @"Look ma, spending from a multisig account.");
        XCTAssertEqualObjects(transaction.idem, @"");
        XCTAssertEqualObjects(transaction.type, @"multisig");
        XCTAssertTrue(transaction.isSigned);
        XCTAssertEqual(transaction.signaturesNeeded, 0);
        XCTAssertEqual(transaction.signaturesPresent, 2);
        XCTAssertEqual(transaction.signaturesRequired, 2);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__getOAuthApplications
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/oauth/applications").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOAuthApplications"];

    [self.client getOAuthApplications:^(NSArray *applications, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(applications, "applications should not be nil");

        CoinbaseApplication *application = [applications objectAtIndex:0];

        XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);

        XCTAssertEqualObjects(application.applicationID, @"52fe8cf2137f733087000002");
        XCTAssertTrue([application.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(application.name, @"Dummy");
        XCTAssertEqualObjects(application.redirectURL, @"http://example.com");
        XCTAssertEqual(application.numberOfUsers, 0);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getOAuthApplicationWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/oauth/applications/52fe8cf2137f733087000002").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOAuthApplicationWithID"];

    [self.client getOAuthApplicationWithID:@"52fe8cf2137f733087000002" completion:^(CoinbaseApplication *application, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(application, "application should not be nil");

        XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);

        XCTAssertEqualObjects(application.applicationID, @"5302ebdb137f73dcf7000047");
        XCTAssertTrue([application.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(application.name, @"Test App 3");
        XCTAssertEqualObjects(application.redirectURL, @"http://example.com");
        XCTAssertEqual(application.numberOfUsers, 0);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__createOAuthApplicationWithName_reDirectURL
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/oauth/applications").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOAuthApplicationWithID"];

    [self.client createOAuthApplicationWithName:@"Test App 3" reDirectURL:@"http://example.com" completion:^(CoinbaseApplication *application, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(application, "application should not be nil");

        XCTAssertTrue([application isKindOfClass:[CoinbaseApplication class]]);

        XCTAssertEqualObjects(application.applicationID, @"5302ebdb137f73dcf7000047");
        XCTAssertTrue([application.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(application.name, @"Test App 3");
        XCTAssertEqualObjects(application.redirectURL, @"http://example.com");
        XCTAssertEqual(application.numberOfUsers, 0);
        XCTAssertEqualObjects(application.clientID, @"ee0ed3e5092e75e2b66afed97ecb54b8408b5e1b153f9841ce3f9c555f45db74");
        XCTAssertEqualObjects(application.clientSecret, @"8c9217790a1fc001a37d09aa2d28e218868242390670f41440822dbb1173fe58");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getOrders
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/orders").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOrders"];

    [self.client getOrders:^(NSArray *orders, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(orders, "orders should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");

        CoinbaseOrder *order = [orders objectAtIndex:0];

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"A7C52JQT");
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"100000000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"3000");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"USD");
        XCTAssertEqualObjects(order.status, @"completed");
        XCTAssertEqualObjects(order.custom, @"");
        XCTAssertEqualObjects(order.receiveAddress, @"mgrmKftH5CeuFBU3THLWuTNKaZoCGJU5jQ");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"Order #1234");
        XCTAssertEqualObjects(order.button.buttonDescription, @"order description");
        XCTAssertEqualObjects(order.button.buttonID, @"eec6d08e9e215195a471eae432a49fc7");
        XCTAssertEqualObjects(order.transaction.transactionID, @"513eb768f12a9cf27400000b");
#warning is it hsh or hash?
        //XCTAssertEqualObjects(order.transaction.hashString, @"4cc5eec20cd692f3cdb7fc264a0e1d78b9a7e3d7b862dec1e39cf7e37ababc14");
        XCTAssertEqual(order.transaction.confirmations, 0);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void)test__createOrderWithName
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/orders").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST createOrderWithName"];

    [self.client createOrderWithName:@"test" price:@"1.23" priceCurrencyISO:@"USD" completion:^(CoinbaseOrder *order, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(order, "order should not be nil");

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"8QNULQFE");
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"12300000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"123");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"USD");
        XCTAssertEqualObjects(order.status, @"new");
        XCTAssertEqualObjects(order.receiveAddress, @"mnskjZs57dBAmeU2n4csiRKoQcGRF4tpxH");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"test");
        XCTAssertEqualObjects(order.button.buttonID, @"1741b3be1eb5dc50625c48851a94ae13");
        XCTAssertEqualObjects(order.transaction.transactionID, nil);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getOrderWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/orders/A7C52JQT").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getOrderWithID"];

    [self.client getOrderWithID:@"A7C52JQT" completion:^(CoinbaseOrder *order, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(order, "order should not be nil");

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"A7C52JQT");
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"10000000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"10000000");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"BTC");
        XCTAssertEqualObjects(order.status, @"completed");
        XCTAssertEqualObjects(order.custom, @"custom123");
        XCTAssertEqualObjects(order.receiveAddress, @"mgrmKftH5CeuFBU3THLWuTNKaZoCGJU5jQ");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"test");
        XCTAssertEqualObjects(order.button.buttonDescription, @"");
        XCTAssertEqualObjects(order.button.buttonID, @"eec6d08e9e215195a471eae432a49fc7");
        XCTAssertEqualObjects(order.transaction.transactionID, @"513eb768f12a9cf27400000b");
#warning is it hsh or hash?
        //       XCTAssertEqualObjects(order.transaction.hashString, @"4cc5eec20cd692f3cdb7fc264a0e1d78b9a7e3d7b862dec1e39cf7e37ababc14");
        XCTAssertEqual(order.transaction.confirmations, 0);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__refundOrderWithID_refundISOCode
{
    stubRequest(@"POST", @"https://coinbase.com/api/v1/orders/A7C52JQT/refund").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"POST refundOrderWithID_refundISOCode"];

    [self.client refundOrderWithID:@"A7C52JQT" refundISOCode:@"BTC" completion:^(CoinbaseOrder *order, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(order, "order should not be nil");

        XCTAssertTrue([order isKindOfClass:[CoinbaseOrder class]]);
        XCTAssertEqualObjects(order.orderID, @"YYZQ6RN4");
        XCTAssertEqualObjects(order.event, [NSNull null]);
        XCTAssertTrue([order.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([order.totalBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalBitcoins.cents, @"10000000");
        XCTAssertEqualObjects(order.totalBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([order.totalNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalNative.cents, @"100");
        XCTAssertEqualObjects(order.totalNative.currencyISO, @"USD");
        XCTAssertTrue([order.totalPayout isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(order.totalPayout.cents, @"100");
        XCTAssertEqualObjects(order.totalPayout.currencyISO, @"USD");
        XCTAssertEqualObjects(order.status, @"completed");
        XCTAssertEqualObjects(order.custom, @"");
        XCTAssertEqualObjects(order.receiveAddress, @"mmUFLyAtF89mcvStdobiby3xFpdLARQhNw");
        XCTAssertTrue([order.button isKindOfClass:[CoinbaseButton class]]);
        XCTAssertEqualObjects(order.button.type, @"buy_now");
        XCTAssertEqualObjects(order.button.name, @"asdfasdf");
        XCTAssertEqualObjects(order.button.buttonDescription, @"");
        XCTAssertEqualObjects(order.button.buttonID, @"320421614991df1e2d526b8169644067");
        XCTAssertEqualObjects(order.refundAddress, @"n49yYq81iZxqyKj2ys85ErXLJp9EBPNqis");

        XCTAssertEqualObjects(order.transaction.transactionID, @"53a0c9ee137f734abb0001db");
#warning is it hsh or hash?
        //       XCTAssertEqualObjects(order.transaction.hashString, @"5d4751d532ba6845f09c24d21a8b1153e96f2b19fcfab84591b3a3be78648998");
        XCTAssertEqual(order.transaction.confirmations, 101);

        XCTAssertEqualObjects(order.refundTransaction.transactionID, @"53a22f33137f734abb000296");
#warning is it hsh or hash?
        //       XCTAssertEqualObjects(order.refundTransaction.hashString, @"ce401504150a02618ca8ee93e5b948c59e30040b6101473a07a97e77c6c4be1c");
        XCTAssertEqual(order.refundTransaction.confirmations, 0);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getPaymentMethods
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/payment_methods").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getPaymentMethods"];

    [self.client getPaymentMethods:^(NSArray *paymentMethods, NSString *defaultBuy, NSString *defaultSell, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(paymentMethods, "paymentMethods should not be nil");

        CoinbasePaymentMethod *firstPaymentMethod = [paymentMethods objectAtIndex:0];

        XCTAssertTrue([firstPaymentMethod isKindOfClass:[CoinbasePaymentMethod class]]);
        XCTAssertEqualObjects(firstPaymentMethod.paymentMethodID, @"530eb5b217cb34e07a000011");
        XCTAssertEqualObjects(firstPaymentMethod.name, @"US Bank ****4567");
        XCTAssertTrue(firstPaymentMethod.canBuy);
        XCTAssertTrue(firstPaymentMethod.canSell);

        CoinbasePaymentMethod *secondPaymentMethod = [paymentMethods objectAtIndex:1];

        XCTAssertTrue([secondPaymentMethod isKindOfClass:[CoinbasePaymentMethod class]]);
        XCTAssertEqualObjects(secondPaymentMethod.paymentMethodID, @"530eb7e817cb34e07a00001a");
        XCTAssertEqualObjects(secondPaymentMethod.name, @"VISA card 1111");
        XCTAssertFalse(secondPaymentMethod.canBuy);
        XCTAssertFalse(secondPaymentMethod.canSell);

        XCTAssertEqualObjects(defaultBuy, @"530eb5b217cb34e07a000011");
        XCTAssertEqualObjects(defaultSell, @"530eb5b217cb34e07a000011");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__paymentMethodWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/payment_methods/530eb5b217cb34e07a000011").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET paymentMethodWithID"];

    [self.client paymentMethodWithID:@"530eb5b217cb34e07a000011" completion:^(CoinbasePaymentMethod *paymentMethod, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(paymentMethod, "paymentMethod should not be nil");

        XCTAssertTrue([paymentMethod isKindOfClass:[CoinbasePaymentMethod class]]);
        XCTAssertEqualObjects(paymentMethod.paymentMethodID, @"530eb5b217cb34e07a000011");
        XCTAssertEqualObjects(paymentMethod.name, @"US Bank ****4567");
        XCTAssertTrue(paymentMethod.canBuy);
        XCTAssertTrue(paymentMethod.canSell);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getBuyPrice
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/prices/buy").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getBuyPrice"];

    [self.client getBuyPrice:^(CoinbaseBalance *btc, NSArray *fees, CoinbaseBalance *subtotal, CoinbaseBalance *total, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(btc, "btc should not be nil");
        XCTAssertNotNil(fees, "fees should not be nil");
        XCTAssertNotNil(subtotal, "subtotal should not be nil");
        XCTAssertNotNil(total, "total should not be nil");

        XCTAssertTrue([fees isKindOfClass:[NSArray class]]);

        XCTAssertTrue([subtotal isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(subtotal.amount, @"10.10");
        XCTAssertEqualObjects(subtotal.currency, @"USD");

        XCTAssertTrue([subtotal isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(subtotal.amount, @"10.10");
        XCTAssertEqualObjects(subtotal.currency, @"USD");

        XCTAssertTrue([total isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(total.amount, @"10.35");
        XCTAssertEqualObjects(total.currency, @"USD");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getSellPrice
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/prices/sell").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getSellPrice"];

    [self.client getSellPrice:^(CoinbaseBalance *btc, NSArray *fees, CoinbaseBalance *subtotal, CoinbaseBalance *total, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(btc, "btc should not be nil");
        XCTAssertNotNil(fees, "fees should not be nil");
        XCTAssertNotNil(subtotal, "subtotal should not be nil");
        XCTAssertNotNil(total, "total should not be nil");

        XCTAssertTrue([fees isKindOfClass:[NSArray class]]);

        XCTAssertTrue([subtotal isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(subtotal.amount, @"9.90");
        XCTAssertEqualObjects(subtotal.currency, @"USD");

        XCTAssertTrue([total isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(total.amount, @"9.65");
        XCTAssertEqualObjects(total.currency, @"USD");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getSpotRate
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/prices/spot_rate").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getSpotRate"];

    [self.client getSpotRate:^(CoinbaseBalance *spotRate, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(spotRate, "spotRate should not be nil");

        XCTAssertTrue([spotRate isKindOfClass:[CoinbaseBalance class]]);
        XCTAssertEqualObjects(spotRate.amount, @"10.00");
        XCTAssertEqualObjects(spotRate.currency, @"USD");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getRecurringPayments
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/recurring_payments").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getRecurringPayments"];

    [self.client getRecurringPayments:^(NSArray *recurringPayments, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(recurringPayments, "recurringPayments should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");

        CoinbaseRecurringPayment *firstRecurringPayment = [recurringPayments objectAtIndex:0];

        XCTAssertTrue([firstRecurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
        XCTAssertEqualObjects(firstRecurringPayment.recurringPaymentID, @"51a7b9e9f8182b4b22000013");
        XCTAssertEqualObjects(firstRecurringPayment.type, @"send");
        XCTAssertEqualObjects(firstRecurringPayment.status, @"active");
        XCTAssertTrue([firstRecurringPayment.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(firstRecurringPayment.to, @"user2@example.com");
        XCTAssertEqualObjects(firstRecurringPayment.from, [NSNull null]);
        XCTAssertEqualObjects(firstRecurringPayment.startType, @"now");
        XCTAssertEqual(firstRecurringPayment.times, -1);
        XCTAssertEqual(firstRecurringPayment.timesRun, 7);
        XCTAssertEqualObjects(firstRecurringPayment.repeat, @"monthly");
        XCTAssertTrue([firstRecurringPayment.lastRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([firstRecurringPayment.nextRun isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(firstRecurringPayment.notes, [NSNull null]);
        XCTAssertEqualObjects(firstRecurringPayment.recurringPaymentDescription, @"Send 0.02 BTC to User Two");
        XCTAssertEqualObjects(firstRecurringPayment.amount.amount, @"0.02000000");
        XCTAssertEqualObjects(firstRecurringPayment.amount.currency, @"BTC");

        CoinbaseRecurringPayment *secondRecurringPayment = [recurringPayments objectAtIndex:1];

        XCTAssertTrue([secondRecurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
        XCTAssertEqualObjects(secondRecurringPayment.recurringPaymentID, @"5193377ef8182b7c19000015");
        XCTAssertEqualObjects(secondRecurringPayment.type, @"request");
        XCTAssertEqualObjects(secondRecurringPayment.status, @"completed");
        XCTAssertTrue([secondRecurringPayment.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(secondRecurringPayment.to, @"");
        XCTAssertEqualObjects(secondRecurringPayment.from, @"user1@example.com");
        XCTAssertEqualObjects(secondRecurringPayment.startType, @"now");
        XCTAssertEqual(secondRecurringPayment.times, 3);
        XCTAssertEqual(secondRecurringPayment.timesRun, 3);
        XCTAssertEqualObjects(secondRecurringPayment.repeat, @"daily");
        XCTAssertTrue([secondRecurringPayment.lastRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([secondRecurringPayment.nextRun isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(secondRecurringPayment.notes, @"");
        XCTAssertEqualObjects(secondRecurringPayment.recurringPaymentDescription, @"Request 0.01 BTC from user1@example.com");
        XCTAssertEqualObjects(secondRecurringPayment.amount.amount, @"0.01000000");
        XCTAssertEqualObjects(secondRecurringPayment.amount.currency, @"BTC");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__recurringPaymentWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/recurring_payments/5193377ef8182b7c19000015").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET recurringPaymentWithID"];

    [self.client recurringPaymentWithID:@"5193377ef8182b7c19000015" completion:^(CoinbaseRecurringPayment *recurringPayment, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(recurringPayment, "recurringPayment should not be nil");

        XCTAssertTrue([recurringPayment isKindOfClass:[CoinbaseRecurringPayment class]]);
        XCTAssertEqualObjects(recurringPayment.recurringPaymentID, @"5193377ef8182b7c19000015");
        XCTAssertEqualObjects(recurringPayment.type, @"send");
        XCTAssertEqualObjects(recurringPayment.status, @"active");
        XCTAssertTrue([recurringPayment.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(recurringPayment.to, @"user2@example.com");
        XCTAssertEqualObjects(recurringPayment.from, [NSNull null]);
        XCTAssertEqualObjects(recurringPayment.startType, @"now");
        XCTAssertEqual(recurringPayment.times, -1);
        XCTAssertEqual(recurringPayment.timesRun, 7);
        XCTAssertEqualObjects(recurringPayment.repeat, @"monthly");
        XCTAssertTrue([recurringPayment.lastRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([recurringPayment.nextRun isKindOfClass:[NSDate class]]);
        XCTAssertEqualObjects(recurringPayment.notes, [NSNull null]);
        XCTAssertEqualObjects(recurringPayment.recurringPaymentDescription, @"Send 0.02 BTC to User Two");
        XCTAssertEqualObjects(recurringPayment.amount.amount, @"0.02000000");
        XCTAssertEqualObjects(recurringPayment.amount.currency, @"BTC");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__refundWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/refunds/L9HBEX9R").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET refundWithID"];

    [self.client refundWithID:@"L9HBEX9R" completion:^(CoinbaseRefund *refund, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(refund, "refund should not be nil");

        XCTAssertTrue([refund isKindOfClass:[CoinbaseRefund class]]);
        XCTAssertEqualObjects(refund.refundID, @"L9HBEX9R");
        XCTAssertTrue([refund.creationDate isKindOfClass:[NSDate class]]);
        XCTAssertTrue([refund.amountBitcoins isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(refund.amountBitcoins.cents, @"10000000.0");
        XCTAssertEqualObjects(refund.amountBitcoins.currencyISO, @"BTC");
        XCTAssertTrue([refund.amountNative isKindOfClass:[CoinbasePrice class]]);
        XCTAssertEqualObjects(refund.amountNative.cents, @"100.0");
        XCTAssertEqualObjects(refund.amountNative.currencyISO, @"USD");
        XCTAssertEqualObjects(refund.transferID, [NSNull null]);
        XCTAssertEqualObjects(refund.transactionID, @"54d94335ef634f12f8000342");
        XCTAssertEqualObjects(refund.refundableID, @"54d19395ef634f53d400009a");
        XCTAssertEqualObjects(refund.refundableType, @"order");

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__getReports
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/reports").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET getReports"];

    [self.client getReports:^(NSArray *reports, CoinbasePagingHelper *paging, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(reports, "reports should not be nil");
        XCTAssertNotNil(paging, "paging should not be nil");

        CoinbaseReport *report = [reports objectAtIndex:0];

        XCTAssertTrue([report isKindOfClass:[CoinbaseReport class]]);
        XCTAssertEqualObjects(report.reportID, @"53463bf8137f730e1c000060");
        XCTAssertEqualObjects(report.type, @"orders");
        XCTAssertEqualObjects(report.status, @"completed");
        XCTAssertEqualObjects(report.email, @"admin@example.com");
        XCTAssertEqualObjects(report.repeat, @"never");
        XCTAssertEqualObjects(report.timeRange, @"past_30");
        XCTAssertEqualObjects(report.callBackURL,[NSNull null]);
        XCTAssertEqualObjects(report.fileURL, @"http://localhost:3000");
        XCTAssertEqual(report.times, -1);
        XCTAssertEqual(report.timesRun, 1);

        XCTAssertTrue([report.lastRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([report.nextRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([report.creationDate isKindOfClass:[NSDate class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__reportWithID
{
    stubRequest(@"GET", @"https://coinbase.com/api/v1/reports/533e5de1137f73ccf1000139").
    andReturn(200).
    withHeaders(@{@"Content-Type": @"application/json"}).
    withBody([self loadMockJSONFromFile]);

    XCTestExpectation *expectation = [self expectationWithDescription:@"GET reportWithID"];

    [self.client reportWithID:@"533e5de1137f73ccf1000139" completion:^(CoinbaseReport *report, NSError *error) {

        XCTAssertNil(error);
        XCTAssertNotNil(report, "report should not be nil");

        XCTAssertTrue([report isKindOfClass:[CoinbaseReport class]]);
        XCTAssertEqualObjects(report.reportID, @"5347146a137f730e1c0000cb");
        XCTAssertEqualObjects(report.type, @"transactions");
        XCTAssertEqualObjects(report.status, @"completed");
        XCTAssertEqualObjects(report.email, @"dummy@example.com");
        XCTAssertEqualObjects(report.repeat, @"never");
        XCTAssertEqualObjects(report.timeRange, @"past_30");
        XCTAssertEqualObjects(report.callBackURL,[NSNull null]);
        XCTAssertEqualObjects(report.fileURL, @"http://localhost:3000");
        XCTAssertEqual(report.times, -1);
        XCTAssertEqual(report.timesRun, 1);

        XCTAssertTrue([report.lastRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([report.nextRun isKindOfClass:[NSDate class]]);
        XCTAssertTrue([report.creationDate isKindOfClass:[NSDate class]]);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.1 handler:^(NSError *error) {
        NSLog(@"Expectation error = %@", error.description);
    }];
}

-(void) test__createReportWithType_email
{

}

-(void) test__sellQuantity
{

}

-(void) test__getSubscribers
{

}

-(void) test__subscriptionWithID
{

}

-(void) test__createToken
{

}

-(void) test__redeemTokenWithID
{

}

-(void) test__getTransactions
{

}

-(void) test__transactionWithID
{

}

-(void) test__sendAmount_to
{

}

-(void) test__transferAmount_to
{

}

-(void) test__requestAmount_from
{

}

-(void) test__resendRequestWithID
{

}

-(void) test__completeRequestWithID
{

}

-(void) test__cancelRequestWithID
{

}

-(void) test__getTransfers
{

}

-(void) test__transferWithID
{

}

-(void) test__commitTransferWithID
{

}

-(void) test__getCurrentUser
{

}

-(void) test__modifyCurrentUserName
{

}

-(void) test__withdrawAmount_accountID_paymentMethodID
{

}


@end



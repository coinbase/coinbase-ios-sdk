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
        XCTAssertTrue(order.totalNative, @"new");
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
        XCTAssertTrue(order.totalNative, @"new");
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

}

-(void)test__createMultiSigAccountWithName_type_requiredSignatures_xPubKeys
{
   
}

- (void)test__getSignatureHashesWithTransactionID
{

}

-(void)test__signaturesForMultiSigTransaction
{

}

-(void)test__getOAuthApplications
{

}

-(void) test__getOAuthApplicationWithID
{

}

-(void) test__createOAuthApplicationWithName_reDirectURL
{

}

-(void) test__getOrders
{

}

-(void)test__createOrderWithName
{

}

-(void) test__getOrderWithID
{

}

-(void) test__refundOrderWithID_refundISOCode
{

}

-(void) test__getPaymentMethods
{

}

-(void) test__paymentMethodWithID
{

}

-(void) test__getBuyPrice
{

}

-(void) test__getSellPrice
{

}

-(void) test__getSpotRate
{

}

-(void) test__getRecurringPayments
{

}

-(void) test__recurringPaymentWithID
{

}

-(void) test__refundWithID
{

}

-(void) test__getReports
{

}

-(void) test__reportWithID
{

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



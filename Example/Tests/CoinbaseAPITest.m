//
//  CoinbaseAPITest.m
//  coinbase
//
//  Created by Dai Hovey on 06/05/2015.
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

@interface CoinbaseAPITest : XCTestCase

@end

@implementation CoinbaseAPITest

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

// Endpoints. method name == plist name (plist contains test JSON response)

// getAccountsList

- (void)test__getAccountsList
{
    [self testRequestType:CoinbaseRequestTypeGet path:@"accounts" parameters:nil headers:nil completion:^(id response, NSError *error) {

        CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[[response objectForKey:@"accounts"] objectAtIndex:0]];

        //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);

        CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];

        //XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
    }];
}

// getAccount

- (void)test__getAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
    {
        CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

        //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
    }];
}

// getPrimaryAccount

- (void)test__getPrimaryAccount
{
    [self testRequestType:CoinbaseRequestTypeGet path:@"accounts/primary" parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

         //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
     }];
}

// createAccountWithName

- (void)test__createAccountWithName
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : @"TEST NAME"}};

    [self testRequestType:CoinbaseRequestTypePost path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

         //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
     }];
}

// getBalanceForAccount

- (void)test__getBalanceForAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/balance", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];

         //XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);
     }];
}

// getBitcoinAddressForAccount

- (void)test__getBitcoinAddressForAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];

         //XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
     }];
}

// createBitcoinAddressForAccount

- (void)test__createBitcoinAddressForAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypePost path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];

         //XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
     }];
}

// modifyAccount

- (void)test__modifyAccount_name_completion
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : @"TEST NAME"}};

    NSString *path = [NSString stringWithFormat:@"accounts/536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypePut path:path parameters:parameters headers:nil completion:^(id response, NSError *error)
     {
         CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

         //XCTAssertTrue([address isKindOfClass:[CoinbaseAccount class]]);
     }];
}

// setAccountAsPrimary

- (void)test__setAccountAsPrimary
{
    NSString *path = [NSString stringWithFormat:@"accounts/accounts/536a541fa9393bb3c7000034/primary"];

    [self testRequestType:CoinbaseRequestTypePut path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         BOOL success = [[response objectForKey:@"success"] boolValue];

         //XCTAssertTrue(success);
     }];
}

// deleteAccount

- (void)test__deleteAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/accounts/536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeDelete path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         BOOL success = [[response objectForKey:@"success"] boolValue];

         //XCTAssertTrue(success);
     }];
}

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



///////

//- (void)test__
//{
//    NSString *path = [NSString stringWithFormat:@"accounts/accounts/536a541fa9393bb3c7000034"];
//
//    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
//     {
//
//             // XCTAssertTrue([user isKindOfClass:[CoinbaseUser class]]);
//     }];
//}


@end

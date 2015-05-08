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

- (void)test_getAccountsList
{
    [self testRequestType:CoinbaseRequestTypeGet path:@"accounts" parameters:nil headers:nil completion:^(id response, NSError *error) {

        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[[response objectForKey:@"accounts"] objectAtIndex:0]];

            //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);

            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];

            //XCTAssertTrue([pagingHelper isKindOfClass:[CoinbasePagingHelper class]]);
        }
    }];
}

// getAccount

- (void)test_getAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
    {
        if ([response isKindOfClass:[NSDictionary class]])
        {
            CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

            //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
        }
    }];
}

// getPrimaryAccount

- (void)test_getPrimaryAccount
{
    [self testRequestType:CoinbaseRequestTypeGet path:@"accounts/primary" parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         if ([response isKindOfClass:[NSDictionary class]])
         {
             CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

             //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
         }
     }];
}

// createAccountWithName

- (void)test_createAccountWithName
{
    NSDictionary *parameters = @{@"account" :
                                     @{@"name" : @"TEST NAME"}};

    [self testRequestType:CoinbaseRequestTypePost path:@"accounts" parameters:parameters headers:nil completion:^(id response, NSError *error)
     {
         if ([response isKindOfClass:[NSDictionary class]])
         {
             CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithDictionary:[response objectForKey:@"account"]];

             //XCTAssertTrue([account isKindOfClass:[CoinbaseAccount class]]);
         }
     }];
}

// getBalanceForAccount

- (void)test_getBalanceForAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/balance", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         if ([response isKindOfClass:[NSDictionary class]])
         {
             CoinbaseBalance *balance = [[CoinbaseBalance alloc] initWithDictionary:response];

             //XCTAssertTrue([balance isKindOfClass:[CoinbaseBalance class]]);
         }
     }];
}

// getBitcoinAddressForAccount

- (void)test_getBitcoinAddressForAccount
{
    NSString *path = [NSString stringWithFormat:@"accounts/%@/address", @"536a541fa9393bb3c7000034"];

    [self testRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error)
     {
         if ([response isKindOfClass:[NSDictionary class]])
         {
             CoinbaseAddress *address = [[CoinbaseAddress alloc] initWithDictionary:response];

             //XCTAssertTrue([address isKindOfClass:[CoinbaseAddress class]]);
         }
     }];
}


@end

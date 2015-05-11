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
#import "CoinbaseTransfer.h"
#import "CoinbaseContact.h"
#import "CoinbaseCurrency.h"

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

@end
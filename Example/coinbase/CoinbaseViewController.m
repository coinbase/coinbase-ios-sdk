//
//  CoinbaseViewController.m
//  coinbase
//
//  Created by Isaac Waller on 08/21/2014.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import "CoinbaseAppDelegate.h"
#import "CoinbaseOAuth.h"
#import "CoinbaseViewController.h"
#import "coinbase-Swift.h"
#import "Coinbase.h"

@interface CoinbaseViewController ()

@property (nonatomic, retain) Coinbase *client;
@property (nonatomic, strong) NSString *accessToken;

@end

@implementation CoinbaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];

    if (self.accessToken)
    {
        self.client = [Coinbase coinbaseWithOAuthAccessToken:self.accessToken];

        [self test];
    }
}

- (IBAction)startAuthentication:(id)sender {
    // Launch the web browser or Coinbase app to authenticate the user.
    [CoinbaseOAuth startOAuthAuthenticationWithClientId:kCoinbaseDemoClientID
                                                  scope:@"all"
                                            redirectUri:@"org.cocoapods.demo.coinbase.coinbase-oauth://coinbase-oauth"
                                                   meta:nil];
}

- (void)authenticationComplete:(NSDictionary *)response
{
    // Tokens successfully received!
    self.accessToken = [response objectForKey:@"access_token"];

    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *refreshToken = [response objectForKey:@"refresh_token"];
    // NSNumber *expiresIn = [response objectForKey:@"expires_in"];
    // In your app, you will probably want to save these three values at this point.
    self.refreshToken = refreshToken;

    // Now that we are authenticated, load some data
    self.client = [Coinbase coinbaseWithOAuthAccessToken:self.accessToken];

    [self.client getAccountsList:^(id result, NSError *error)
     {
         if (error)
         {
             NSLog(@"Could not load: %@", error);
         }
         else
         {
             NSArray *accounts = result[@"accounts"];
             NSString *text = @"";
             for (NSDictionary *account in accounts) {
                 NSString *name = account[@"name"];
                 NSDictionary *balance = account[@"balance"];
                 text = [text stringByAppendingString:[NSString stringWithFormat:@"%@: %@ %@\n", name, balance[@"amount"], balance[@"currency"]]];
             }
             self.balanceLabel.text = text;
         }
     }];
}

- (void)refreshTokens:(id)sender {
    self.emailLabel.text = @"Refreshing tokens...";
    [CoinbaseOAuth getOAuthTokensForRefreshToken:self.refreshToken clientId:kCoinbaseDemoClientID clientSecret:kCoinbaseDemoClientSecret completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"Could not refresh tokens: %@", error);
        } else {
            //            // New tokens obtained
            //            self.emailLabel.text = @"Got new tokens, loading email";
            //            self.refreshToken = [response objectForKey:@"refresh_token"];
            //            self.client = [Coinbase coinbaseWithOAuthAccessToken:[response objectForKey:@"access_token"]];
            //            [self.client doGet:@"users" parameters:nil completion:^(id result, NSError *error) {
            //                if (error) {
            //                    NSLog(@"Could not load: %@", error);
            //                } else {
            //                    self.emailLabel.text = [[[[result objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
            //                }
            //            }];
        }
    }];
}

-(void) test
{
//    [self.client getAccountsList:^(NSArray *accounts, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getAccountsList - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getAccountsList = %@", accounts);
//        }
//    }];
//
//    [self.client getAccountsListWithPage:0 limit:25 allAccounts:YES completion:^(NSArray *accounts, CoinbasePagingHelper *pagingHelper, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getAccountsListWithPage - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getAccountsListWithPage = %@", accounts);
//
//        }
//    }];

//    [self.client getAccount:@"53cf5e6a70ea76ce5b000006" completion:^(CoinbaseAccount *account, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getAccount - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getAccount = %@", account);
//        }
//    }];

//    [self.client getPrimaryAccount:^(CoinbaseAccount *account, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getPrimaryAccount - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getPrimaryAccount = %@", account);
//        }
//    }];

//    [self.client createAccountWithName:@"SDK TEST ACCOUNT" completion:^(CoinbaseAccount *account, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"createAccountWithName - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"createAccountWithName = %@", response);
//        }
//    }];

//    [self.client getBalanceForAccount:@"53cf5e6a70ea76ce5b000006" completion:^(id response, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getBalanceForAccount - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getBalanceForAccount = %@", response);
//        }
//    }];

//    [self.client getBitcoinAddressForAccount:@"53cf5e6a70ea76ce5b000006" completion:^(CoinbaseAddress *address, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getBitcoinAddressForAccount - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getBitcoinAddressForAccount = %@", address);
//        }
//    }];

//        [self.client createBitcoinAddressForAccount:@"53cf5e6a70ea76ce5b000006" completion:^(CoinbaseAddress *address, NSError *error) {
//    
//            if (error)
//            {
//                NSLog(@"createBitcoinAddressForAccount - Could not load : %@", error);
//            }
//            else
//            {
//                NSLog(@"createBitcoinAddressForAccount = %@", address);
//            }
//        }];

//    [self.client getAccountAddresses:^(NSArray *addresses, NSError *error) {
//
//        if (error)
//        {
//            NSLog(@"getAccountAddresses - Could not load : %@", error);
//        }
//        else
//        {
//            NSLog(@"getAccountAddresses = %@", addresses);
//        }
//    }];

        [self.client getCurrentUser:^(CoinbaseUser *user, NSError *error) {

            if (error)
            {
                NSLog(@"getCurrentUser - Could not load : %@", error);
            }
            else
            {
                NSLog(@"getCurrentUser = %@", user);
            }
        }];
}

@end

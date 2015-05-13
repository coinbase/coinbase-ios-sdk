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
#import "CoinbaseAccount.h"
#import "CoinbaseUser.h"
#import "CoinbasePagingHelper.h"

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
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

     [self updateUI];
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

    [self updateUI];
}

- (void)refreshTokens:(id)sender {
    self.emailLabel.text = @"Refreshing tokens...";
    [CoinbaseOAuth getOAuthTokensForRefreshToken:self.refreshToken
                                        clientId:kCoinbaseDemoClientID
                                    clientSecret:kCoinbaseDemoClientSecret
                                      completion:^(id response, NSError *error) {
        if (error) {
            NSLog(@"Could not refresh tokens: %@", error);
        } else {
            // New tokens obtained
            self.emailLabel.text = @"Got new tokens, loading email";
            self.refreshToken = [response objectForKey:@"refresh_token"];
            self.client = [Coinbase coinbaseWithOAuthAccessToken:[response objectForKey:@"access_token"]];

            [self.client getCurrentUser:^(CoinbaseUser *user, NSError *error)
            {
                if (error)
                {
                    NSLog(@"Could not load user: %@", error);
                }
                else
                {
                    self.emailLabel.text = user.email;
                }
            }];
        }
    }];
}

-(void) updateUI
{
    if (self.accessToken)
    {
        self.listTransactionsButton.enabled = self.listUserAccountsButton.enabled = self.refreshTokenButton.enabled = YES;

        [self.client getAccountsList:^(NSArray *accounts, CoinbasePagingHelper *paging, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Could not load: %@", error);
             }
             else
             {
                 for (CoinbaseAccount *primaryAccount in accounts)
                 {
                     if (primaryAccount.primary == YES)
                     {
                         self.balanceLabel.text = [NSString stringWithFormat:@"%@: %@ %@\n", primaryAccount.name, primaryAccount.balance.amount, primaryAccount.balance.currency];
                     }
                 }
             }
         }];

        [self.client getCurrentUser:^(CoinbaseUser *user, NSError *error)
        {
            if (error)
            {
                NSLog(@"Could not load user: %@", error);
            }
            else
            {
                self.emailLabel.text = user.email;
            }
        }];

        self.authenticationButton.titleLabel.text = @"Sign Out of Coinbase";
    }
    else
    {
        self.listTransactionsButton.enabled = self.listUserAccountsButton.enabled = self.refreshTokenButton.enabled = NO;

        self.authenticationButton.titleLabel.text = @"Sign in with Coinbase";
    }
}

@end

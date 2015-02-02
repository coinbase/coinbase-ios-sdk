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

@interface CoinbaseViewController ()

@property (nonatomic, retain) Coinbase *client;

@end

@implementation CoinbaseViewController

- (IBAction)startAuthentication:(id)sender {
    // Launch the web browser or Coinbase app to authenticate the user.
    [CoinbaseOAuth startOAuthAuthenticationWithClientId:kCoinbaseDemoClientID
                                             scope:@"user balance"
                                       redirectUri:@"org.cocoapods.demo.coinbase.coinbase-oauth://coinbase-oauth"
                                              meta:nil];
}

- (void)authenticationComplete:(NSDictionary *)response {
    // Tokens successfully received!
    NSString *accessToken = [response objectForKey:@"access_token"];
    NSString *refreshToken = [response objectForKey:@"refresh_token"];
    NSNumber *expiresIn = [response objectForKey:@"expires_in"];
    // In your app, you will probably want to save these three values at this point.
    self.refreshToken = refreshToken;
    
    // Now that we are authenticated, load some data
    self.client = [Coinbase coinbaseWithOAuthAccessToken:accessToken];
    [self.client doGet:@"accounts" parameters:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Could not load: %@", error);
        } else {
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

    [self.client doGet:@"users" parameters:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"Could not load: %@", error);
        } else {
            self.emailLabel.text = [[[[result objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
        }
    }];
}

- (void)refreshTokens:(id)sender {
    self.emailLabel.text = @"Refreshing tokens...";
    [CoinbaseOAuth getOAuthTokensForRefreshToken:self.refreshToken clientId:kCoinbaseDemoClientID clientSecret:kCoinbaseDemoClientSecret success:^(NSDictionary *response) {
        // New tokens obtained
        self.emailLabel.text = @"Got new tokens, loading email";
        self.refreshToken = [response objectForKey:@"refresh_token"];
        self.client = [Coinbase coinbaseWithOAuthAccessToken:[response objectForKey:@"access_token"]];
        [self.client doGet:@"users" parameters:nil completion:^(id result, NSError *error) {
            if (error) {
                NSLog(@"Could not load: %@", error);
            } else {
                self.emailLabel.text = [[[[result objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Could not refresh tokens: %@", error);
    }];
}

@end

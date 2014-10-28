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

@interface CoinbaseViewController ()

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
    Coinbase *apiClient = [Coinbase coinbaseWithOAuthAccessToken:accessToken];
    [apiClient doGet:@"account/balance" parameters:nil success:^(NSDictionary *result) {
        self.balanceLabel.text = [[result objectForKey:@"amount"] stringByAppendingFormat:@" %@", [result objectForKey:@"currency"]];
    } failure:^(NSError *error) {
        NSLog(@"Could not load: %@", error);
    }];
    [apiClient doGet:@"users" parameters:nil success:^(NSDictionary *result) {
        self.emailLabel.text = [[[[result objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
    } failure:^(NSError *error) {
        NSLog(@"Could not load: %@", error);
    }];
}

- (void)refreshTokens:(id)sender {
    self.emailLabel.text = @"Refreshing tokens...";
    [CoinbaseOAuth getOAuthTokensForRefreshToken:self.refreshToken clientId:kCoinbaseDemoClientID clientSecret:kCoinbaseDemoClientSecret success:^(NSDictionary *response) {
        // New tokens obtained
        self.emailLabel.text = @"Got new tokens, loading email";
        self.refreshToken = [response objectForKey:@"refresh_token"];
        Coinbase *apiClient = [Coinbase coinbaseWithOAuthAccessToken:[response objectForKey:@"access_token"]];
        [apiClient doGet:@"users" parameters:nil success:^(NSDictionary *result) {
            self.emailLabel.text = [[[[result objectForKey:@"users"] objectAtIndex:0] objectForKey:@"user"] objectForKey:@"email"];
        } failure:^(NSError *error) {
            NSLog(@"Could not load: %@", error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Could not refresh tokens: %@", error);
    }];
}

@end

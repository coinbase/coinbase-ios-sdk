//
//  CoinbaseOAuth2LeggedViewController.m
//  coinbase
//
//  Created by Isaac Waller on 10/28/14.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import "CoinbaseOAuth2LeggedViewController.h"
#import "CoinbaseOAuth.h"
#import "CoinbaseAppDelegate.h"

@interface CoinbaseOAuth2LeggedViewController ()

@end

@implementation CoinbaseOAuth2LeggedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)signIn:(id)sender {
    self.status.text = @"Requesting authorization code";
    [CoinbaseOAuth doOAuthAuthenticationWithUsername:self.email.text
                                            password:self.password.text
                                               token:self.token.text
                                            clientId:kCoinbaseDemoClientID
                                        clientSecret:kCoinbaseDemoClientSecret
                                               scope:@"all"
                                         redirectUri:nil
                                                meta:nil
                                             success:^(NSString *code) {
                                                 [self gotCode:code];
                                             }
                                             failure:^(NSError *error) {
                                                 NSLog(@"Received error %@", error);
                                             }];
}

- (void)gotCode:(NSString *)code {
    self.status.text = @"Got code, requesting tokens";
    [CoinbaseOAuth getOAuthTokensForCode:code
                             redirectUri:@"2_legged"
                                clientId:kCoinbaseDemoClientID
                            clientSecret:kCoinbaseDemoClientSecret
                                 success:^(NSDictionary *success) {
                                     [self gotTokens:success];
                                 }
                                 failure:^(NSError *error) {
                                     NSLog(@"Received error %@", error);
                                 }];
}

- (void)gotTokens:(NSDictionary *)tokens {
    self.status.text = @"Got tokens, making request";
    NSString *accessToken = [tokens objectForKey:@"access_token"];
    Coinbase *coinbase = [Coinbase coinbaseWithOAuthAccessToken:accessToken];
    [coinbase doGet:@"account/balance"
         parameters:nil
            success:^(NSDictionary *response) {
                self.status.text = [NSString stringWithFormat:@"%@ %@", [response objectForKey:@"amount"], [response objectForKey:@"currency"]];
            }
            failure:^(NSError *error) {
                NSLog(@"Received error %@", error);
            }];
}

@end

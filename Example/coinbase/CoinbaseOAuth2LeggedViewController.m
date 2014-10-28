//
//  CoinbaseOAuth2LeggedViewController.m
//  coinbase
//
//  Created by Isaac Waller on 10/28/14.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import "CoinbaseOAuth2LeggedViewController.h"
#import "Coinbase.h"
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
    [Coinbase doOAuthAuthenticationWithUsername:self.email.text
                                       password:self.password.text
                                          token:self.token.text
                                       clientId:kCoinbaseDemoClientID
                                   clientSecret:kCoinbaseDemoClientSecret
                                          scope:@"all"
                                    redirectUri:nil
                                           meta:nil
                                        success:^(NSDictionary *response) {
                                            
                                            [self getTokensWithCode:[response objectForKey:@"code"]];
                                        }
                                        failure:^(NSError *error) {
                                            NSLog(@"Received error %@", error);
                                        }];
}

- (void)getTokensWithCode:(NSString *)code {
    
}

@end

//
//  CoinbaseAppDelegate.m
//  coinbase
//
//  Created by CocoaPods on 08/21/2014.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import "CoinbaseAppDelegate.h"
#import "Coinbase.h"
#import "CoinbaseOAuth.h"
#import "CoinbaseViewController.h"

@implementation CoinbaseAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([[url scheme] isEqualToString:@"org.cocoapods.demo.coinbase.coinbase-oauth"]) {
        // This is a redirect from the Coinbase OAuth web page or app.
        [CoinbaseOAuth finishOAuthAuthenticationForUrl:url
                                                clientId:kCoinbaseDemoClientID
                                            clientSecret:kCoinbaseDemoClientSecret
                                                 success:^(NSDictionary *result) {
            // Tokens successfully obtained!
            CoinbaseViewController *controller = (CoinbaseViewController *)self.window.rootViewController;
            [controller authenticationComplete:result];
        } failure:^(NSError *error) {
            // Could not authenticate.
            [[[UIAlertView alloc] initWithTitle:@"OAuth Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }];
        return YES;
    }
    return NO;
    
}

@end

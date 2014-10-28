//
//  CoinbaseOAuth2LeggedViewController.h
//  coinbase
//
//  Created by Isaac Waller on 10/28/14.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinbaseOAuth2LeggedViewController : UIViewController

@property IBOutlet UITextField *email;
@property IBOutlet UITextField *password;
@property IBOutlet UITextField *token;
@property IBOutlet UILabel *status;

- (IBAction)close:(id)sender;
- (IBAction)signIn:(id)sender;

@end

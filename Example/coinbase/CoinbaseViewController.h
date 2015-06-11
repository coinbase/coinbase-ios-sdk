//
//  CoinbaseViewController.h
//  coinbase
//
//  Created by Isaac Waller on 08/21/2014.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinbaseViewController : UIViewController

- (IBAction)handleAuthentication:(id)sender;
- (void)authenticationComplete:(NSDictionary *)response;
- (IBAction)refreshTokens:(id)sender;

@property (weak) IBOutlet UILabel *emailLabel;
@property (weak) IBOutlet UILabel *balanceLabel;
@property (weak) IBOutlet UIButton *authenticationButton;
@property (weak) IBOutlet UIButton *listUserAccountsButton;
@property (weak) IBOutlet UIButton *listTransactionsButton;
@property (weak) IBOutlet UIButton *refreshTokenButton;
@property (strong) NSString *refreshToken;

@end

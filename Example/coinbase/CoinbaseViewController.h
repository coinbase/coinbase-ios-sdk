//
//  CoinbaseViewController.h
//  coinbase
//
//  Created by Isaac Waller on 08/21/2014.
//  Copyright (c) 2014 Isaac Waller. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coinbase/Coinbase.h"

@interface CoinbaseViewController : UIViewController

- (IBAction)startAuthentication:(id)sender;
- (void)authenticationComplete:(NSDictionary *)response;
- (IBAction)refreshTokens:(id)sender;

@property (weak) IBOutlet UILabel *emailLabel;
@property (weak) IBOutlet UILabel *balanceLabel;
@property (strong) NSString *refreshToken;

@end

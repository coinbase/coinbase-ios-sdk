//
//  CoinbaseAccountsTableViewController.m
//  coinbase
//
//  Created by Dai Hovey on 29/04/2015.
//  Copyright (c) 2015 Isaac Waller. All rights reserved.
//

#import "CoinbaseAccountsTableViewController.h"
#import "Coinbase.h"
#import "CoinbaseAccount.h"

@interface CoinbaseAccountsTableViewController ()

@property (nonatomic, strong) NSArray *accounts;

@end

@implementation CoinbaseAccountsTableViewController

-(void) viewDidLoad
{
    [super viewDidLoad];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];

    if (accessToken)
    {
        Coinbase *client = [Coinbase coinbaseWithOAuthAccessToken:accessToken];

        [client getAccountsList:^(NSArray *accounts, CoinbasePagingHelper *paging, NSError *error)
         {
             if (error)
             {
                 [[[UIAlertView alloc] initWithTitle:@"Error"
                                             message:[NSString stringWithFormat:@"Could not load: %@", error.localizedDescription]
                                            delegate:nil
                                   cancelButtonTitle:@"OK"
                                   otherButtonTitles:nil] show];
             }
             else
             {
                 self.accounts = accounts;
                 [self.tableView reloadData];
             }
         }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"account"];

    CoinbaseAccount *account = [self.accounts objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@ BTC", account.name, account.balance.amount];
    
    return cell;
}

@end

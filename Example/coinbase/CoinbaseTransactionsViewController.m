//
//  CoinbaseTransactionsViewController.m
//  coinbase
//
//  Created by Dai Hovey on 29/04/2015.
//  Copyright (c) 2015 Isaac Waller. All rights reserved.
//

#import "CoinbaseTransactionsViewController.h"
#import "Coinbase.h"
#import "CoinbaseTransaction.h"

@interface CoinbaseTransactionsViewController ()

@property (nonatomic, strong) NSArray *transactions;
@property (nonatomic, strong) CoinbaseUser *currentUser;

@end

@implementation CoinbaseTransactionsViewController

-(void) viewDidLoad
{
    [super viewDidLoad];

    NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"access_token"];

    if (accessToken)
    {
        Coinbase *client = [Coinbase coinbaseWithOAuthAccessToken:accessToken];

        [client getTransactions:^(NSArray *transactions,
                                  CoinbaseUser *user,
                                  CoinbaseBalance *balance,
                                  CoinbaseBalance *nativebalance,
                                  CoinbasePagingHelper *paging,
                                  NSError *error)
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
                self.transactions = transactions;
                self.currentUser = user;
                [self.tableView reloadData];
            }
         }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.transactions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"transaction"];

    CoinbaseTransaction *transaction = [self.transactions objectAtIndex:indexPath.row];

    UILabel *cellLabel = (UILabel*)[cell.contentView viewWithTag:1];
    CGFloat amountFloat = [transaction.amount.amount floatValue];

    if ([self.currentUser.userID isEqualToString:transaction.recipient.userID])
    {
        cellLabel.text = [NSString stringWithFormat:@"Received %.6f BTC from %@", amountFloat, transaction.sender.email];
    }
    else
    {
        cellLabel.text = [NSString stringWithFormat:@"Sent %.6f BTC to %@", amountFloat, transaction.recipient.email];
    }

    return cell;
}

@end


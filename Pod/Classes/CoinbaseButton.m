//
//  CoinbaseButton.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseButton.h"
#import "CoinbaseOrder.h"

@implementation CoinbaseButton

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
        _buttonID = [dictionary objectForKey:@"id"];
        _code = [dictionary objectForKey:@"code"];
        _type = [dictionary objectForKey:@"type"];
        _subscription = [[dictionary objectForKey:@"subscription"] boolValue];
        _style = [dictionary objectForKey:@"style"];
        _text = [dictionary objectForKey:@"text"];
        _name = [dictionary objectForKey:@"name"];
        _buttonDescription = [dictionary objectForKey:@"description"];
        _custom = [dictionary objectForKey:@"custom"];
        _callbackURL = [dictionary objectForKey:@"callback_url"];
        _price = [[CoinbasePrice alloc] initWithDictionary:[dictionary objectForKey:@"price"]];
    }
    return self;
}

-(void)getOrdersForButton:(void(^)(NSArray*, CoinbasePagingHelper*, NSError*))callback;
{
    NSString *path = [NSString stringWithFormat:@"buttons/%@/orders", _buttonID];

    [super doRequestType:CoinbaseRequestTypeGet path:path parameters:nil headers:nil completion:^(id response, NSError *error) {

        if (error)
        {
            callback(nil, nil, error);
            return;
        }

        if ([response isKindOfClass:[NSDictionary class]])
        {
            NSArray *responseOrders = [response objectForKey:@"orders"];

            NSMutableArray *orders = [[NSMutableArray alloc] initWithCapacity:responseOrders.count];

            for (NSDictionary *dictionary in responseOrders)
            {
                CoinbaseOrder *order = [[CoinbaseOrder alloc] initWithDictionary:[dictionary objectForKey:@"order"]];
                [orders addObject:order];
            }
            CoinbasePagingHelper *pagingHelper = [[CoinbasePagingHelper alloc] initWithDictionary:response];
            callback(orders, pagingHelper, error);
        }
    }];
}

@end


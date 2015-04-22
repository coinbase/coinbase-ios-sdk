//
//  CoinbaseButton.m
//  Pods
//
//  Created by Dai Hovey on 22/04/2015.
//
//

#import "CoinbaseButton.h"

@implementation CoinbaseButton

-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self)
    {
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

@end
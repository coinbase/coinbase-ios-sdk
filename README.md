# coinbase

Integrate bitcoin into your iOS application with Coinbase's fully featured bitcoin payments API. Coinbase allows all major operations in bitcoin through one API. For more information, visit https://developers.coinbase.com/docs/wallet.

To try the example project, install [CocoaPods](http://cocoapods.org), then run `pod try coinbase-official`.

[![Version](https://img.shields.io/cocoapods/v/coinbase-official.svg?style=flat)](http://cocoadocs.org/docsets/coinbase-official)
[![License](https://img.shields.io/cocoapods/l/coinbase-official.svg?style=flat)](http://cocoadocs.org/docsets/coinbase-official)
[![Platform](https://img.shields.io/cocoapods/p/coinbase-official.svg?style=flat)](http://cocoadocs.org/docsets/coinbase-official)
[![Build Status](https://travis-ci.org/coinbase/coinbase-ios-sdk.svg?branch=master)](https://travis-ci.org/coinbase/coinbase-ios-sdk?branch=master)

## Installation

coinbase is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "coinbase-official"

## Authentication

The Coinbase iOS SDK can be used with both Coinbase API keys and OAuth2 authentication. Use API keys if you only need to access your own Coinbase account from within your application. Use OAuth2 if you need to access your user's accounts. Most iOS apps will need to use OAuth2.

### OAuth2

OAuth2 allows you to access other user's accounts. If the Coinbase app is installed on the user's phone, authenticating with OAuth2 is just a single tap.

![Animation of OAuth process](http://i.imgur.com/Uikav7g.gif)

If the Coinbase app is not installed authentication will seamlessly fall back to Safari.

To use OAuth2 you will need to add a custom URI scheme to your application. This URI scheme must start with your app's bundle identifier. For example, if your bundle ID is "com.example.app", your URI scheme could be "com.example.app.coinbase-oauth". To add a URI scheme:

1. In Xcode, click on your project in the Project Navigator
2. Select your app's target
3. Click Info
4. Open URL Types
5. Click "+" to create a new URL Type
6. Enter your new URL scheme in both Identifier and URL Schemes

You now need to create an OAuth2 application for your iOS application at [https://www.coinbase.com/oauth/applications](https://www.coinbase.com/oauth/applications). Click `+ Create an Application` and enter a name for your application. In `Permitted Redirect URIs`, you should enter "your_scheme://coinbase-oauth" - for example, if your custom URI scheme is "com.example.app.coinbase-oauth", then you should enter "com.example.app.coinbase-oauth://coinbase-oauth". Save the application and take note of the Client ID and Secret.

You can now integrate the OAuth2 sign in flow into your application. Use `startOAuthAuthenticationWithClientId:scope:redirectUri:meta:` to start the external sign in process.

```objective-c
// Launch the web browser or Coinbase app to authenticate the user.
[CoinbaseOAuth startOAuthAuthenticationWithClientId:@"your client ID"
                                         scope:@"user balance"
                                   redirectUri:@"com.example.app.coinbase-oauth://coinbase-oauth" // Same as entered into Create Application
                                          meta:nil];
```
```swift
CoinbaseOAuth.startOAuthAuthenticationWithClientId("your client ID", scope: "user balance", redirectUri: "com.example.app.coinbase-oauth://coinbase-oauth", meta: nil)
```

You must override `openURL` in your application delegate to receive the OAuth authorization grant code and pass it back in to the Coinbase SDK.

```objective-c
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    if ([[url scheme] isEqualToString:@"com.example.app.coinbase-oauth"]) {
        // This is a redirect from the Coinbase OAuth web page or app.
        [CoinbaseOAuth finishOAuthAuthenticationForUrl:url
                                                clientId:@"your client ID"
                                            clientSecret:@"your client secret"
                                              completion:^(id result, NSError *error) {
            if (error) {
                // Could not authenticate.
            } else {
                // Tokens successfully obtained!
                // Do something with them (store them, etc.)
                Coinbase *apiClient = [Coinbase coinbaseWithOAuthAccessToken:[result objectForKey:@"access_token"]];
                // Note that you should also store 'expire_in' and refresh the token using [CoinbaseOAuth getOAuthTokensForRefreshToken] when it expires
            }
        }];
        return YES;
    }
    return NO;

}
```
```swift
if url.scheme == "com.example.app.coinbase-oauth" {
            CoinbaseOAuth.finishOAuthAuthenticationForUrl(url, clientId: "your client ID", clientSecret: "your client secret", completion: { (result : AnyObject?, error: NSError?) -> Void in
                if error != nil {
                    // Could not authenticate.
                } else {
                    // Tokens successfully obtained!
                    // Do something with them (store them, etc.)
                    if let result = result as? [String : AnyObject] {
                        if let accessToken = result["access_token"] as? String {
                            let apiClient = Coinbase(OAuthAccessToken: accessToken)
                        }
                    }
                    // Note that you should also store 'expire_in' and refresh the token using CoinbaseOAuth.getOAuthTokensForRefreshToken() when it expires
                }
            })
            return true
        }
        else {
            return false
        }
```

See the `Example` folder for a fully functional example.


### API key authentication

Simply use `coinbaseWithApiKey:secret:`. Example:

```objective-c
Coinbase *apiClient = [Coinbase coinbaseWithApiKey:myKey secret:mySecret];
```
```swift
let coinbase = Coinbase(apiKey: myKey, secret: mySecret)
```

## Usage

After creating a `Coinbase` object using one of the authentication methods above, the API methods at [https://developers.coinbase.com/api](https://developers.coinbase.com/api) can be called using the convenience methods on `Coinbase`. Example:

```objective-c
[apiClient getCurrentUser:^(CoinbaseUser *user, NSError *error) {
    if (error) {
        NSLog(@"Could not load user: %@", error);
    } else {
        NSLog(@"Signed in as: %@", user.email);
    }
}];

CoinbaseAccount *account = [[CoinbaseAccount alloc] initWithID:@"536a541fa9393bb3c7000034" client:apiClient];

[account getBalance:^(CoinbaseBalance *balance, NSError *error) {
    if (error) {
        NSLog(@"Could not get balance: %@", error);
    } else {
        NSLog(@"User's balance: %@ in %@", balance.amount, balance.currency);
    }
}];

```

```swift
   Coinbase().getSupportedCurrencies() { (response: Array?, error: NSError?) in

       if let error = error {
           NSLog("Error: \(error)")
       } else {
           self.currencies = (response as? [CoinbaseCurrency])!
           self.tableView.reloadData()
       }
   }

   Coinbase().getBuyPrice { (btc: CoinbaseBalance?, fees: Array?, subtotal: CoinbaseBalance?, total: CoinbaseBalance?, error: NSError?) in

            if let error = error {
                NSLog("Error: \(error)")
            } else {
                self.buyTotal.text = "Buy Price: \(total!.amount!) BTC"
            }
        }

```

## License

coinbase is available under the MIT license. See the LICENSE file for more info.

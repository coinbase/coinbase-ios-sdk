# Coinbase iOS SDK

*This library is deprecated.*

*Thank you all for your contributions.*

![Platform](https://img.shields.io/badge/platform-iOS_11%2B-blue.svg)
[![Language](https://img.shields.io/badge/language-swift_4.2-4BC51D.svg)](https://developer.apple.com/swift)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg)](https://github.com/Carthage/Carthage)
[![CocoaPods compatible](https://img.shields.io/cocoapods/v/coinbase-official.svg?style=flat)](http://cocoadocs.org/docsets/coinbase-official)
![License](https://img.shields.io/cocoapods/l/coinbase-official.svg?style=flat)

## Table of Contents

- [Installation](#installation)
- [Basic usage](#basic-usage)
- [RxSwift](#rxswift)
- [Examples](#examples)
- [Testing](#testing)
- [License](#license)

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Coinbase SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'coinbase-official', '~> 4.0'
```

Then, run the following command:

```bash
$ pod install
```

If you want to use the RxSwift extensions for Coinbase SDK add:

```ruby
pod 'coinbase-official/RxSwift', '~> 4.0'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Coinbase SDK into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "coinbase/coinbase-ios-sdk"
```
 
Run `carthage update` to build the framework and drag the built `CoinbaseSDK.framework` into your Xcode project. If you want to use the RxSwift extensions for Coinbase SDK add `RxCoinbaseSDK.framework` into your project as well.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding Coinbase SDK as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
        .package(url: "https://github.com/coinbase/coinbase-ios-sdk")
    ]
```

And in the target where you want to use it:

```swift
targets: [
    .target(
        name: "<project_name>",
        dependencies: ["CoinbaseSDK"])
]
```

If you want to use the RxSwift extensions for Coinbase SDK add to target's `dependencies`: `"RxCoinbaseSDK"`.

#### Important
Swift Package Manager currently does not support resources. Coinbase SDK requires additional resource files to work properly (Trusted SSL Certificates). If you want to use Swift Package Manager you should provide those resources manually.

You can find the required resources in Coinbase iOS SDK GitHub repository under  `Source/Supporting Files/PinnedCertificates` path. Collect those files and add them to your project.

- Using Xcode:
    
    You should additionally configure `CoinbaseSDK` target.
    In tab `Build Phases` add new phase by selecting `New Copy File Phase`. 
    Drag and Drop required resources to this phase.

- Using console:

    To provide the required resources you should copy them to a location with built files. 

    Example: If required files are located in directory `Resources` and you building for `x86_64-apple-macosx10.10` platform in `debug` mode then resources can be copied with the command:

    ```bash
    cp Resources/* ./.build/x86_64-apple-macosx10.10/debug
    ```

## Basic usage

 In source file where you want to use CoinbaseSDK add:

```swift
import CoinbaseSDK
```

 If you want to use the RxSwift extensions for CoinbaseSDK using not CocoaPods, please import RxCoinbaseSDK by adding the following line:

```swift
import RxCoinbaseSDK
```

To use CoinbaseSDK you need to have an instance of `Coinbase` class.
You can create a new `Coinbase` instance:

```swift
let coinbase = Coinbase()
```

Or you can use convenience static instance:

```swift
Coinbase.default
```

### Authentication

To work with resources which require authentication you should provide a valid access token to Coinbase instance.

Access token can be provided either directly by setting its value to `coinbase`'s property:

```swift 
coinbase.accessToken = accessToken
```

or by passing it to the initializer:

```swift 
let coinbase = Coinbase(accessToken: accessToken)
```

If you do not provide an access token to the instance of Coinbase you can successfully work with **only** the next resources:

1. `CurrenciesResource`
2. `ExchangeRatesResource`
3. `PricesResource`
4. `TimeResource`

### Getting access token

To get an access token the Coinbase iOS SDK uses OAuth2 authentication. 

You should call `configure` method on `oauth` property of Coinbase instance to set all required properties before calling any authorization method:

```swift
coinbase.oauth.configure(clientID: <client_id>,
                         clientSecret: <client_secret>,
                         redirectURI: <redirect_uri>)
```

Then you can initiate OAuth flow by calling `beginAuthorization`

``` swift
try coinbase.oauth.beginAuthorization(scope: [Scope.Wallet.Accounts.read, ...])
```

It will redirect user into Safari browser where they can authorize your application.

In `AppDelegate` you should handle redirection back by calling `coinbase.oauth.completeAuthorization` method inside `application(_:open:options:)`

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handleCoinbaseOAuth = coinbase.oauth.completeAuthorization(url) { result in
            // setup coinbase, e.g. coinbase.accessToken = result.value?.accessToken
        }
        return handleCoinbaseOAuth
    }
```

To get a detailed guide on how to use OAuth2 with CoinbaseSDK read [Getting Acess Token](https://github.com/coinbase/coinbase-ios-sdk/wiki/Getting-Access-Token).

#### Note

Coinbase instace for `completeAuthorization` call should be the same as you used to call `beginAuthorization` method.

#### Important

*Access token* lifetime is pretty short and after the expiration, it should be refreshed with the *refresh token*.

You can perform refresh manually or allow auto-refresh by calling `setRefreshStrategy` with `TokenRefreshStrategy.refresh` on Coinbase instance.

Reed more about `TokenRefreshStrategy` in [Token refreshing](https://github.com/coinbase/coinbase-ios-sdk/wiki/Token-refreshing).

## RxSwift 

CoinbaseSDK provides wrappers that allow you to use it with RxSwift. To get more information about how to use it [read page](https://github.com/coinbase/coinbase-ios-sdk/wiki/RxSwift-extension).

## Examples

To see more details on how to work with CoinbaseSDK you can check sample app or read some [Coinbase Examples](https://github.com/coinbase/coinbase-ios-sdk/wiki/Examples).

### Sample app

To be able to use Coinbase SDK iOS Example app you should setup OAuth2 application keys. You can get the required keys after creating Coinbase OAuth2 Application.
* Log in to your Coinbase account and create a new [OAuth2 application](https://www.coinbase.com/oauth/applications/new) (or get an existing one). 
* In application details page you can get `clientId`, `clientSecret` and `redirectUri`. 
* Open Coinbase workspace then inside `iOS Example` project fill empty values for `OAuth2ApplicationKeys` in `Source/Constants.swift` file.
* Register custom scheme used in your `redirectURI`. In `Info.plist` file add:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>Coinbase OAuth Scheme</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>[redirect_uri_scheme]</string>
        </array>
    </dict>
</array>
```

#### Note:
Make sure that you used the same URI scheme in `redirectURI` constant and your `Info.plist` file.

For example, if your `[redirect_uri_scheme]` is `com.example.app`, then your redirect URI can be: `com.example.app://callback`
## Testing

To be able to run tests, you should download dependencies. To do so, run:
``` 
carthage bootstrap --platform iOS
```

If you do not have Carthage installed, check the [installation instructions](https://github.com/Carthage/Carthage#installing-carthage).

After that, you can open `Coinbase.xcworkspace` and select `CoinbaseSDK` target and hit ⌘+U to start testing.

## License

Coinbase is available under the Apache License 2.0. [See LICENSE](https://github.com/coinbase/coinbase-ios-sdk/blob/master/LICENSE) file for more info.

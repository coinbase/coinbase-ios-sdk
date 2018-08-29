// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoinbaseSDK",
    products: [
        .library(name: "CoinbaseSDK", targets: ["CoinbaseSDK"]),
        .library(name: "RxCoinbaseSDK", targets: ["RxCoinbaseSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", "4.0.0" ..< "5.0.0")
    ],
    targets: [
        .target(name: "CoinbaseSDK", 
                dependencies: [],
                path: "Source",
                exclude: ["Extentions/RxSwift"]),
        .target(name: "RxCoinbaseSDK", 
                dependencies: ["RxSwift"],
                path: "Source/Extentions/RxSwift"),        
    ]
)

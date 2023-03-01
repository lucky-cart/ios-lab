// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LuckyCartSDK",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "LuckyCartSDK",
            targets: ["LuckyCartSDK"]),
    ],
    dependencies: [
         .package(url: "https://github.com/SDWebImage/SDWebImage.git",
                  from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "LuckyCartSDK",
            dependencies: ["SDWebImage"]),
        .testTarget(
            name: "LuckyCartSDKTests",
            dependencies: ["LuckyCartSDK"]),
    ]
)

// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "FCM",
    platforms: [
       .macOS(.v10_14)
    ],
    products: [
        //Vapor client for Firebase Cloud Messaging
        .library(name: "FCM", targets: ["FCM"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.2"),
        .package(url: "https://github.com/vapor/jwt.git", from: "4.0.0-beta.2"),
    ],
    targets: [
        .target(name: "FCM", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "FCMTests", dependencies: ["FCM"]),
    ]
)

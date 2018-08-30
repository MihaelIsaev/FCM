// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "FCM",
    products: [
        //Vapor client for Firebase Cloud Messaging
        .library(name: "FCM", targets: ["FCM"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/jwt.git", from: "3.0.0"),
    ],
    targets: [
        .target(name: "FCM", dependencies: ["Vapor", "JWT"]),
        .testTarget(name: "FCMTests", dependencies: ["FCM"]),
    ]
)
